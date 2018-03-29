class GameDetail30th < GameDetail
  # 勝敗
  #   相手本陣の全ての風船を割った時点で勝ち
  #   相手ロボットの全ての風船を割った時点で勝ち
  #   3分終了後、相手本陣の風船を自陣より多く割った方の勝ち
  #   本陣が同数の場合、相手ロボットの風船を自陣より多く割った方の勝ち
  #   いずれも同数の場合は審査員判定
  # 審査員判定
  #   地区3名、全国？名
  # リペア
  #   リトライではなくリペア
  #   何回でも可能
  # 反則
  #   反則5回で失格
  #   審判の判断によっては反則の回数に因らず失格となることもある

  module Constant
    BALOON_MIN = 0
    BALOON_MAX = 10
  end

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code base_baloon robot_baloon repair penalty jury_votes )

  UNKNOWN = GameDetail::Constant::UNKNOWN_VALUE

  REX_BL = /\A([0-9]\z|\A10\z|\A#{UNKNOWN})\z/
  REX_RP = /\A[0-9]\z|\A#{UNKNOWN}\z/
  REX_PN = /\A[0-5]\z|\A#{UNKNOWN}\z/
  REX_VT = /\A[0-5]\z|\A#{UNKNOWN}\z/

  attr_accessor :my_robot_baloon, :opponent_robot_baloon
  attr_accessor :my_base_baloon,  :opponent_base_baloon
  attr_accessor :my_repair,       :opponent_repair
  attr_accessor :my_penalty,      :opponent_penalty
  attr_accessor :time_minute, :time_second
  attr_accessor :jury_votes, :my_jury_votes, :opponent_jury_votes
  attr_accessor :memo

  validates :my_base_baloon,        format: { with: REX_BL }
  validates :opponent_base_baloon,  format: { with: REX_BL }
  validates :my_robot_baloon,       format: { with: REX_BL }
  validates :opponent_robot_baloon, format: { with: REX_BL }
  validates :my_repair,             format: { with: REX_RP }
  validates :opponent_repair,       format: { with: REX_RP }
  validates :my_penalty,            format: { with: REX_PN }
  validates :opponent_penalty,      format: { with: REX_PN }
  validates :time_minute,           format: { with: REX_MS }
  validates :time_second,           format: { with: REX_MS }
  with_options if: :jury_votes do
    validates :my_jury_votes,       format: { with: REX_VT }
    validates :opponent_jury_votes, format: { with: REX_VT }
  end
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_base_baloon,  :opponent_base_baloon,
      :my_robot_baloon, :opponent_robot_baloon,
      :my_repair,       :opponent_repair,
      :my_penalty,      :opponent_penalty,
      :time_minute, :time_second,
      :jury_votes, :my_jury_votes, :opponent_jury_votes,
      :memo
    ]
  end

  def stems
    STEMS
  end

  def self.compose_properties(hash:)
    h = super(hash: hash) || {}
    h.update(compose_pairs(hash: hash, stems: %w( babase_baloon robot_baloon
      repair penalty jury_votes )))
    hash[:time_minute] = "#{UNKNOWN}" if hash[:time_minute].blank? # 要らないかも
    hash[:time_second] = "#{UNKNOWN}" if hash[:time_second].blank? # 要らないかも
    h.update(compose_pairs(hash: hash))
    h.delete("jury_votes") unless hash["jury_votes"].presence.to_bool
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["base_baloon"].present?
        self.my_base_baloon, self.opponent_base_baloon =
          h["base_baloon"].to_s.split(DELIMITER)
      end
      if h["robot_baloon"].present?
        self.my_robot_baloon, self.opponent_robot_baloon =
          h["robot_baloon"].to_s.split(DELIMITER)
      end
      if h["repair"].present?
        self.my_repair, self.opponent_repair =
          h["repair"].to_s.split(DELIMITER)
      end
      if h["penalty"].present?
        self.my_penalty, self.opponent_penalty =
          h["penalty"].to_s.split(DELIMITER)
      end
      if h["time"].present?
        self.time_minute, self.time_second =
          h["time"].to_s.split(DELIMITER_TIME)
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
