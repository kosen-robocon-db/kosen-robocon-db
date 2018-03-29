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
  STEMS = %w( robot_code progress time_minute time_second gaining_point penalty
     retry jury_votes )

  REX_PR  = /[0-6]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_PN  = /[0-9]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_RT  = /[0-9]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_VT  = /[0-5]|#{GameDetail::Constant::UNKNOWN_VALUE}/

  attr_accessor :my_progress,      :opponent_progress
  attr_accessor :my_time_minute,       :my_time_second
  attr_accessor :opponent_time_minute, :opponent_time_second
  attr_accessor :my_gaining_point, :opponent_gaining_point
  attr_accessor :my_penalty,       :opponent_penalty
  attr_accessor :my_retry,         :opponent_retry
  attr_accessor :jury_votes, :my_jury_votes, :opponent_jury_votes
  attr_accessor :memo

  validates :my_progress,            format: { with: REX_PR }
  validates :opponent_progress,      format: { with: REX_PR }
  validates :my_time_minute,         format: { with: REX_MS }
  validates :my_time_second,         format: { with: REX_MS }
  validates :opponent_time_minute,   format: { with: REX_MS }
  validates :opponent_time_second,   format: { with: REX_MS }
  # 不明の記録を入力できるようにするにはどうしたらよいのか？
  validates :my_gaining_point, numericality: {
    greater_than_or_equal_to: 0, less_than_or_equal_to: 130
  }
  validates :opponent_gaining_point, numericality: {
    greater_than_or_equal_to: 0, less_than_or_equal_to: 130
  }
  validates :my_penalty,             format: { with: REX_PN }
  validates :opponent_penalty,       format: { with: REX_PN }
  validates :my_retry,               format: { with: REX_RT }
  validates :opponent_retry,         format: { with: REX_RT }
  with_options if: :jury_votes do
    validates :my_jury_votes,        format: { with: REX_VT }
    validates :opponent_jury_votes,  format: { with: REX_VT }
  end
  validates :memo, length: { maximum: MEMO_LEN }

  enum progresses: {
    start:                 0, # スタート
    jump_rope_1st:         1, # 第1ロボット二回縄跳び
    jump_rope_2nd:         2, # 第2ロボット二回縄跳び
    jump_rope_3rd:         3, # 第3ロボット二回縄跳び
    turn_around:           4, # 折り返し
    human_robot_jump_rope: 5, # 人間・ロボットの縄跳び
    consecutive_jump_rope: 6  # 連続縄跳びジャンプ
  }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_progress,        :opponent_progress,
      :my_time_minute,       :my_time_second,
      :opponent_time_minute, :opponent_time_second,
      :my_gaining_point,   :opponent_gaining_point,
      :my_penalty,         :opponent_penalty,
      :my_retry,           :opponent_retry,
      :jury_votes, :my_jury_votes, :opponent_jury_votes,
      :memo
    ]
  end

  def stems
    STEMS
  end

  def self.compose_properties(hash:)
    h = super(hash: hash) || {} # 必要なのか？
    if # 準決勝以降でも3分と入れて貰うことにする（暫定）
      hash[:my_time_minute].present? and
      hash[:my_time_second].present? and
      hash[:opponent_time_minute].present? and
      hash[:opponent_time_second].present?
    then
      h["time"] = "\
        #{hash[:my_time_minute]}\
        #{DELIMITER_TIME}\
        #{hash[:my_time_second]}\
        #{DELIMITER}\
        #{hash[:opponent_time_minute]}\
        #{DELIMITER_TIME}\
        #{hash[:opponent_time_second]}\
      ".gsub(/(\s| )+/, '')
    end
    h.update(compose_pairs(hash: hash, stems: %w(progress gaining_point penalty
      retry jury_votes)))
    h.delete("jury_votes") unless hash["jury_votes"].presence.to_bool
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["progress"].present?
        self.my_progress, self.opponent_progress =
          h["progress"].to_s.split(REX_SC)[1..-1]
      end
      if h["time"].present? then
        self.my_time_minute, self.my_time_second,
          self.opponent_time_minute, self.opponent_time_second =
            h["time"].to_s.split(REX_T)
      end
      if h["gaining_point"].present?
        self.my_gaining_point, self.opponent_gaining_point =
          h["gaining_point"].to_s.split(REX_SC)[1..-1]
      end
      if h["penalty"].present?
        self.my_penalty, self.opponent_penalty =
          h["penalty"].to_s.split(DELIMITER)
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
