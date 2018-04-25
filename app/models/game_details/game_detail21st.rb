class GameDetail21st < GameDetail
  # 反則
  # 　反則すると、直前の位置からやり直し。反則5回で失格。
  # リトライ
  #   宣言すると、競技を行っていた一つ前のゾーンから競技再開
  # 完了課題(prgress)
  #   0:スタートゾーン
  #   1:大回転（パイロン）
  #   2:山越え（ハードル）
  #   3:変身（パフォーマンス）
  #   4:ニ足歩行
  #   5:ゴール
  # 勝敗
  #   先にゴールした方が勝ち。
  #   両チームゴールできなかった場合は課題が進んでいる方の勝ち。
  #   両チームがこなした課題が同じ場合は審査員判定。（地区3名、全国？名）
  #   全国大会で予選があり、負けてもそのまま試合を続行してゴール時間を計測。

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code time_minute time_second foul retry progress
    jury_votes )

  REX_F  = /\A([0-5]|#{UNKNOWN})\z/
  REX_RT = /\A([0-9]|#{UNKNOWN})\z/
  REX_P  = /\A[0-6]\z/
  REX_VT = /\A([0-5]|#{UNKNOWN})\z/

  enum progress: {
    unknown:           0, # 不明
    start:             1, # スタートゾーン
    going_round:       2, # 大回転（パイロン）
    crossing_mountain: 3, # 山越え（ハードル）
    transforming:      4, # 変身（パフォーマンス）
    bipedal_walking:   5, # ニ足歩行
    goal:              6  # ゴール
  }

  attr_accessor :my_time_minute, :opponent_time_minute
  attr_accessor :my_time_second, :opponent_time_second
  attr_accessor :my_foul,        :opponent_foul
  attr_accessor :my_retry,       :opponent_retry
  attr_accessor :progress
  attr_accessor :my_progress,    :opponent_progress
  attr_accessor :jury_votes
  attr_accessor :my_jury_votes,  :opponent_jury_votes
  attr_accessor :memo

  validates :my_time_minute,        format: { with: REX_MS }
  validates :opponent_time_minute,  format: { with: REX_MS }
  validates :my_time_second,        format: { with: REX_MS }
  validates :opponent_time_second,  format: { with: REX_MS }
  validates :my_foul,               format: { with: REX_F }
  validates :opponent_foul,         format: { with: REX_F }
  validates :my_retry,              format: { with: REX_RT }
  validates :opponent_retry,        format: { with: REX_RT }
  with_options if: :progress do
    validates :my_progress,         format: { with: REX_P }
    validates :opponent_progress,   format: { with: REX_P }
  end
  with_options if: :jury_votes do
    validates :my_jury_votes,       format: { with: REX_VT }
    validates :opponent_jury_votes, format: { with: REX_VT }
  end
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_time_minute, :opponent_time_minute,
      :my_time_second, :opponent_time_second,
      :my_foul,        :opponent_foul,
      :my_retry,       :opponent_retry,
      :progress,
      :my_progress,    :opponent_progress,
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
    h = super(hash: hash) || {} # robot_code
    h.update(compose_time(hash: hash))
    h.update(compose_pairs(hash: hash,
      stems: %w( foul retry progress jury_votes )))
    h.delete("progress")   unless hash["progress"].presence.to_bool
    h.delete("jury_votes") unless hash["jury_votes"].presence.to_bool
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["time"].present?
        self.my_time_minute, self.my_time_second,
          self.opponent_time_minute, self.opponent_time_second =
            h["time"].to_s.split(DELIMITER_TIME_PAIR)
      end
      if h["foul"].present?
        self.my_foul, self.opponent_foul =
          h["foul"].to_s.split(DELIMITER)
      end
      if h["retry"].present?
        self.my_retry, self.opponent_retry =
          h["retry"].to_s.split(DELIMITER)
      end
      if h["progress"].present?
        self.progress = true
        self.my_progress, self.opponent_progress =
          h["progress"].to_s.split(DELIMITER)
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
