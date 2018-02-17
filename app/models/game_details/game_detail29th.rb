class GameDetail29th < GameDetail

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  ROOTS = %w( robot_code height jury_votes progress )
  
  REX   = /#{DELIMITER}/

  attr_accessor :my_height, :opponent_height
  attr_accessor :jury_votes, :my_jury_votes, :opponent_jury_votes
  attr_accessor :progress, :my_progress, :opponent_progress

  validates :my_height,         numericality: {
    only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 1000
  }
  validates :opponent_height,   numericality: {
    only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 1000
  }
  # validates :jury_votes,             inclusion: { in: ["true", "false"] }
  with_options if: :jury_votes do
    validates :my_jury_votes,       numericality: {
      only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5
    }
    validates :opponent_jury_votes, numericality: {
      only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5
    }
  end
  with_options if: :progress do
    validates :my_progress,       presence: true
    validates :opponent_progress, presence: true
  end

  # DBにはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_height, :opponent_height,
      :jury_votes, :my_jury_votes, :opponent_jury_votes,
      :progress, :my_progress, :opponent_progress
    ]
  end

  def roots
    ROOTS
  end

  # SRP(Single Responsibility Principle, 単一責任原則)に従っていないが
  # このクラス内で実装する。
  def self.compose_properties(hash:)
    h = super(hash: hash) || {}
    ROOTS.each do |pr|
      my_sym, opponent_sym = "my_#{pr}".to_sym, "opponent_#{pr}".to_sym
      if hash[my_sym].present? and hash[opponent_sym].present?
        h["#{pr}"] = "#{hash[my_sym]}-#{hash[opponent_sym]}"
      end
    end
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      self.my_height, self.opponent_height =
        h["height"].to_s.split(REX) if h["height"].present?
      self.jury_votes = h["jury_votes"].present? ? true : false
      self.my_jury_votes, self.opponent_jury_votes =
        h["jury_votes"].to_s.split(REX) if h["jury_votes"].present?
      self.progress = h["progress"].present? ? true : false
      self.my_progress, self.opponent_progress =
        h["progress"].to_s.split(REX) if h["progress"].present?
    end
  end

end
