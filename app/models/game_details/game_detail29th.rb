class GameDetail29th < GameDetail
  REX    = /-/

  attr_accessor :my_height, :opponent_height,
    :jury_votes, :my_jury_votes, :opponent_jury_votes,
    :progress, :my_progress, :opponent_progress

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

  def self.additional_attr_symbols
    [
      :my_height, :opponent_height,
      :jury_votes, :my_jury_votes, :opponent_jury_votes,
      :progress, :my_progress, :opponent_progress
    ]
  end

  def self.attr_syms_for_params
    s = super() || []
    s.concat( additional_attr_symbols )
  end

  # SRP(Single Responsibility Principle, 単一責任原則)に従っていないが
  # このクラス内で実装する。
  def self.compose_properties(hash:)
    logger.debug(">>>> compose_properties, hash:#{hash.to_yaml}")
    h = super(hash: hash) || {}
    properties = %w( height jury_votes progress )
    properties.each do |pr|
      my_sym, opponent_sym = "my_#{pr}".to_sym, "opponent_#{pr}".to_sym
      if hash[my_sym].present? and hash[opponent_sym].present?
        hash["#{pr}"] = "#{hash[my_sym]}-#{hash[opponent_sym]}"
      end
    end
    return h
  end

  # SRP(Single Responsibility Principle, 単一責任原則)に従っていないが
  # このクラス内で実装する。
  # DBには想定外の値がない前提である
  def decompose_properties(robot:)
    h = JSON.parse(self.properties)
    if h["robot"].present? then # テーブルカラムにすべきでは？ 必ずコードがある前提
      self.my_robot_code, self.opponent_robot_code = h["robot"].to_s.split(REX)
    end # テーブルカラムにすれば全ての継承クラスで同じコードを書かなくて済むはず！
    self.my_height, self.opponent_height =
      h["height"].to_s.split(REX) if h["height"].present?
    self.jury_votes = h["jury_votes"].present? ? true : false
    self.my_jury_votes, self.opponent_jury_votes =
      h["jury_votes"].to_s.split(REX) if h["jury_votes"].present?
    self.progress = h["progress"].present? ? true : false
    self.my_progress, self.opponent_progress =
      h["progress"].to_s.split(REX) if h["progress"].present?

    roots = %w( robot_code height jury_votes progress)
    swap_properties(roots) unless robot.code == self.my_robot_code
  end

end
