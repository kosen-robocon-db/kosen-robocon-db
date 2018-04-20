class GameDetail26th < GameDetail
  # 完了課題／課題進捗(progress)
  #   0: スタート（ゾーン）
  #   1: 第1ロボット二回縄跳び（ゾーン）
  #   2: 第2ロボット二回縄跳び（ゾーン）
  #   3: 第3ロボット二回縄跳び（ゾーン）
  #   4: 折り返し（ゾーン）
  #   5: 人間ロボット縄跳び（ゾーン）
  #   6: 連続縄跳びジャンプ（ゾーン）
  # リトライ
  #   何回可能？
  # 審査員判定
  #   同じゾーン完了であれば審査員判定。地区3人、全国？人。
  # 勝敗条件変更
  #   準々決勝までは完了課題数の多い方または５連続ジャンプまでを終えるのが速い方が勝ち。
  #   準決勝以降は完了課題数の多い方または連続ジャンプ数が多い方が勝ち。
  # 試合時間
  #   4分間なのは全国準決勝以降？
  # 反則は？

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code progress time_minute time_second gaining_point foul
     retry jury_votes )

  REX_PR  = /\A([0-6]|#{UNKNOWN})\z/
  REX_GPT = /\A(1[0-2][0-9]|[1-9][0-9]{,1}|0|#{UNKNOWN})\z/
  REX_F   = /\A([0-9]|#{UNKNOWN})\z/
  REX_RT  = /\A([0-9]|#{UNKNOWN})\z/
  REX_VT  = /\A([0-5]|#{UNKNOWN})\z/

  enum progress: {
    start:                 0, # スタート
    first_jump_rope:       1, # 第1ロボット二回縄跳び
    second_jump_rope:      2, # 第2ロボット二回縄跳び
    third_jump_rope:       3, # 第3ロボット二回縄跳び
    turn_around:           4, # 折り返し
    human_robot_jump_rope: 5, # 人間・ロボットの縄跳び
    consecutive_jump_rope: 6  # 連続縄跳びジャンプ
  }

  attr_accessor :my_progress,      :opponent_progress
  attr_accessor :my_time_minute,   :opponent_time_minute
  attr_accessor :my_time_second,   :opponent_time_second
  attr_accessor :my_gaining_point, :opponent_gaining_point
  attr_accessor :my_foul,          :opponent_foul
  attr_accessor :my_retry,         :opponent_retry
  attr_accessor :jury_votes
  attr_accessor :my_jury_votes,    :opponent_jury_votes
  attr_accessor :memo

  validates :my_progress,            format: { with: REX_PR }
  validates :opponent_progress,      format: { with: REX_PR }
  validates :my_time_minute,         format: { with: REX_MS }
  validates :my_time_second,         format: { with: REX_MS }
  validates :opponent_time_minute,   format: { with: REX_MS }
  validates :opponent_time_second,   format: { with: REX_MS }
  validates :my_gaining_point,       format: { with: REX_GPT }
  validates :opponent_gaining_point, format: { with: REX_GPT }
  validates :my_foul,                format: { with: REX_F }
  validates :opponent_foul,          format: { with: REX_F }
  validates :my_retry,               format: { with: REX_RT }
  validates :opponent_retry,         format: { with: REX_RT }
  with_options if: :jury_votes do
    validates :my_jury_votes,        format: { with: REX_VT }
    validates :opponent_jury_votes,  format: { with: REX_VT }
  end
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_progress,      :opponent_progress,
      :my_time_minute,   :opponent_time_minute,
      :my_time_second,   :opponent_time_second,
      :my_gaining_point, :opponent_gaining_point,
      :my_foul,          :opponent_foul,
      :my_retry,         :opponent_retry,
      :jury_votes,
      :my_jury_votes,    :opponent_jury_votes,
      :memo
    ]
  end

  # 親クラスから子クラスのSTEM定数を参照するためのメソッド
  def stems
    STEMS
  end

  # extra_timeなどのbooleanとnilの三種の値の入力を想定しているフォーム属性変数について
  # trueかfalseかnilかをここで吟味すべきであるが、このproperties生成の後に実行される
  # save/update直前のvalidationによって吟味されるので、有るか無しか(nil)かを吟味する
  # だけにしている。他の数字や文字列が入力される属性も同様である。
  def self.compose_properties(hash:)
    h = super(hash: hash) || {} # robot_code
    h.update(compose_pairs(hash: hash, stems: %w( progress )))
    h.update(compose_time(hash: hash))
    h.update(compose_pairs(hash: hash,
      stems: %w( gaining_point foul retry jury_votes )))
    h.delete("jury_votes") unless hash["jury_votes"].presence.to_bool
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["progress"].present?
        self.my_progress, self.opponent_progress =
          h["progress"].to_s.split(DELIMITER)
      end
      if h["time"].present? then
        self.my_time_minute, self.my_time_second,
          self.opponent_time_minute, self.opponent_time_second =
            h["time"].to_s.split(DELIMITER_TIME_PAIR)
      end
      if h["gaining_point"].present?
        self.my_gaining_point, self.opponent_gaining_point =
          h["gaining_point"].to_s.split(DELIMITER)
      end
      if h["foul"].present?
        self.my_foul, self.opponent_foul =
          h["foul"].to_s.split(DELIMITER)
      end
      if h["retry"].present?
        self.my_retry, self.opponent_retry =
          h["retry"].to_s.split(DELIMITER)
      end
      if h["jury_votes"].present?
        self.jury_votes = true
        self.my_jury_votes, self.opponent_jury_votes =
          h["jury_votes"].to_s.split(DELIMITER)
      end
      self.memo = h["memo"].presence || ''
    end
  end

end
