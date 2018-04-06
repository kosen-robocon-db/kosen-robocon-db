class GameDetail23rd < GameDetail

  # 先にゴールした方が勝ち（予選なし）
  # 課題進捗(progress)
  #  0: スタートゾーン
  #  1: 二足歩行ゾーン
  #  2: 連結ゾーン
  #  3: 鍵穴ゾーン
  #  4: ゴール
  # 審査員判定はあったのか？

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code progress time_minute time_second retry jury_votes )

  REX_PR = /\A([0-4]|#{UNKNOWN_VALUE})\z/
  REX_RT = /\A([0-9]|#{UNKNOWN_VALUE})\z/
  REX_VT = /\A([0-5]|#{UNKNOWN_VALUE})\z/

  enum progress: {
    start_zone:      0, # スタートゾーン
    walking_zone:    1, # 二足歩行ゾーン
    connecting_zone: 2, # 連結ゾーン
    inserting_zone:  3, # 鍵穴ゾーン
    goal_zone:       4  # ゴールゾーン
  }

  attr_accessor :my_progress,    :opponent_progress
  attr_accessor :my_time_minute, :opponent_time_minute
  attr_accessor :my_time_second, :opponent_time_second
  attr_accessor :my_retry,       :opponent_retry
  attr_accessor :jury_votes
  attr_accessor :my_jury_votes,  :opponent_jury_votes
  attr_accessor :memo

  validates :my_progress,           format: { with: REX_PR }
  validates :opponent_progress,     format: { with: REX_PR }
  validates :my_time_minute,        format: { with: REX_MS }
  validates :opponent_time_minute,  format: { with: REX_MS }
  validates :my_time_second,        format: { with: REX_MS }
  validates :opponent_time_second,  format: { with: REX_MS }
  validates :my_retry,              format: { with: REX_RT }
  validates :opponent_retry,        format: { with: REX_RT }
  with_options if: :jury_votes do
    validates :my_jury_votes,       format: { with: REX_VT }
    validates :opponent_jury_votes, format: { with: REX_VT }
  end
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_progress,    :opponent_progress,
      :my_time_minute, :opponent_time_minute,
      :my_time_second, :opponent_time_second,
      :my_retry,       :opponent_retry,
      :jury_votes,
      :my_jury_votes,  :opponent_jury_votes,
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
    h = compose_pairs(hash: hash, stems: %w( robot_code progress retry
      jury_votes ))
    h.update(compose_time(hash: hash))
    h.delete("jury_votes") unless hash["jury_votes"].presence.to_bool
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["progress"].present?
        self.progress = true
        self.my_progress, self.opponent_progress =
          h["progress"].to_s.split(DELIMITER)
      end
      if h["time"].present? then
        self.my_time_minute, self.my_time_second,
          self.opponent_time_minute, self.opponent_time_second =
            h["time"].to_s.split(DELIMITER_TIME_PAIR)
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
