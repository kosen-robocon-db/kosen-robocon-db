class GameDetail21st < GameDetail
  # 反則
  # 　反則すると、直前の位置からやり直し。反則5回で失格。
  # リトライ
  #   宣言すると、競技を行っていた一つ前のゾーンから競技再開
  # 課題達成度(prgress)
  #   0:不明, 1:スタート地点, 2:多足歩行ゾーン, 3:パイロン回り完了,
  #   4:ハードル（山）越え中、5:変身ゾーン, 6:変身パフォーマンス完了,
  #   7:2足歩行ゾーン（スラローム）, 8:ゴール
  # 勝敗
  #   先にゴールした方が勝ち。
  #   両チームゴールできなかった場合は課題が進んでいる方の勝ち。
  #   両チームがこなした課題が同じ場合は審査員判定。（地区3名、全国？名）

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code time_minute time_second penalty retry
    progress jury_votes )

  REX_P  = /[0-5]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_RT = /[0-9]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_VT = /[0-5]|#{GameDetail::Constant::UNKNOWN_VALUE}/

  attr_accessor :my_time_minute,       :my_time_second
  attr_accessor :opponent_time_minute, :opponent_time_second
  attr_accessor :my_penalty,           :opponent_penalty
  attr_accessor :my_retry,             :opponent_retry
  attr_accessor :progress,   :my_progress,   :opponent_progress
  attr_accessor :jury_votes, :my_jury_votes, :opponent_jury_votes
  attr_accessor :memo

  validates :my_time_minute,           format: { with: REX_MS }
  validates :my_time_second,           format: { with: REX_MS }
  validates :opponent_time_minute,     format: { with: REX_MS }
  validates :opponent_time_second,     format: { with: REX_MS }
  validates :my_penalty,               format: { with: REX_P }
  validates :opponent_penalty,         format: { with: REX_P }
  validates :my_retry,                 format: { with: REX_RT }
  validates :opponent_retry,           format: { with: REX_RT }
  with_options if: :progress do
    validates :my_progress,       presence: true # 後ほどselectに変更
    validates :opponent_progress, presence: true
  end
  with_options if: :jury_votes do
    validates :my_jury_votes,          format: { with: REX_VT }
    validates :opponent_jury_votes,    format: { with: REX_VT }
  end
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_time_minute,       :my_time_second,
      :opponent_time_minute, :opponent_time_second,
      :my_penalty,           :opponent_penalty,
      :my_retry,             :opponent_retry,
      :progress,   :my_progress,   :opponent_progress,
      :jury_votes, :my_jury_votes, :opponent_jury_votes,
      :memo
    ]
  end

  def stems
    STEMS
  end

  def self.compose_properties(hash:)
    h = super(hash: hash) || {} # robot_code
    h.update(compose_time(hash: hash))
    h.update(compose_pairs(hash: hash,
      stems: %w( penalty retry progress jury_votes )))
    h.delete("progress")   unless hash["progress"].presence.to_bool
    h.delete("jury_votes") unless hash["jury_votes"].presence.to_bool
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["time"].present? then
        self.my_time_minute, self.my_time_second,
          self.opponent_time_minute, self.opponent_time_second =
            h["time"].to_s.split(REX_T)
      end
      if h["penalty"].present?
        self.my_penalty, self.opponent_penalty =
          h["penalty"].to_s.split(DELIMITER)
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
