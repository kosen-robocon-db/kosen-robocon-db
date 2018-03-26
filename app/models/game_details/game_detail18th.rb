class GameDetail18th < GameDetail
  # 反則があると罰鯛で一つ前のゾーンからやり直し（罰退）・・・実装すべきか？
  # 乗り越えた障害（進捗）：
  #  0:不明、1:スタート（地点）、2:梯子潜り、3:平均台渡り、4:ハードル越え、
  #  5:バトン渡し、6:壁登り、7:バトンゴール
  # リトライはスタート地点からやり直し
  # 同じゾーンで同じ障害乗り越え状態であれば、
  # ロボットの最後尾がゴールに近いチームの勝ち（計測判定）
  # スタート地点からバトン受け渡しゾーンまで何ｍ？

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code time_minute time_second retry progress distance
    jury_votes )

  REX_T  = /#{DELIMITER}|#{DELIMITER_TIME}/
  REX_RT = /[0-1]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_VT = /[0-5]|#{GameDetail::Constant::UNKNOWN_VALUE}/

  attr_accessor :my_time_minute,       :my_time_second
  attr_accessor :opponent_time_minute, :opponent_time_second
  attr_accessor :my_retry,             :opponent_retry
  attr_accessor :progress,   :my_progress,   :opponent_progress
  attr_accessor :distance,   :my_distance,   :opponent_distance
  attr_accessor :jury_votes, :my_jury_votes, :opponent_jury_votes
  attr_accessor :memo

  validates :my_time_minute,           format: { with: REX_MS }
  validates :my_time_second,           format: { with: REX_MS }
  validates :opponent_time_minute,     format: { with: REX_MS }
  validates :opponent_time_second,     format: { with: REX_MS }
  validates :my_retry,                 format: { with: REX_RT }
  validates :opponent_retry,           format: { with: REX_RT }
  with_options if: :progress do
    validates :my_progress,       presence: true # 後ほどselectに変更
    validates :opponent_progress, presence: true
  end
  with_options if: :distance do
    validates :my_distance,  numericality: {
      greater_than_or_equal_to: 0, less_than_or_equal_to: 30
    }
    validates :opponent_distance, numericality: {
      greater_than_or_equal_to: 0, less_than_or_equal_to: 30
    }
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
      :my_retry,             :opponent_retry,
      :progress,   :my_progress,   :opponent_progress,
      :distance,   :my_distance,   :opponent_distance,
      :jury_votes, :my_jury_votes, :opponent_jury_votes,
      :memo
    ]
  end

  def stems
    STEMS
  end

  def self.compose_properties(hash:)
    h = super(hash: hash) || {} # robot_code
    if
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
    h.update(compose_pairs(hash: hash,
      stems: %w( retry progress distance jury_votes )))
    h.delete("progress")   unless hash["progress"].presence.to_bool
    h.delete("distance")   unless hash["distance"].presence.to_bool
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
      self.my_retry, self.opponent_retry =
        h["retry"].to_s.split(DELIMITER) if h["retry"].present?
      if h["progress"].present?
        self.progress = true
        self.my_progress, self.opponent_progress =
          h["progress"].to_s.split(DELIMITER)
      end
      if h["distance"].present?
        self.distance = true
        self.my_distance, self.opponent_distance =
          h["distance"].to_s.split(DELIMITER)
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
