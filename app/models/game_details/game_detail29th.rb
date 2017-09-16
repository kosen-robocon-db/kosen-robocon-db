class GameDetail29th < GameDetail
  attr_accessor :my_height, :opponent_height,
    :judge, :judge_to_me, :judge_to_opponent,
    :progress, :my_progress, :opponent_progress

  validates :my_height,         numericality: {
    only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 1000
  }
  validates :opponent_height,   numericality: {
    only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 1000
  }
  # validates :judge,             inclusion: { in: ["true", "false"] }
  with_options if: :judge do
    validates :judge_to_me,       numericality: {
      only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 3
    }
    validates :judge_to_opponent, numericality: {
      only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 3
    }
  end
  with_options if: :progress do
    validates :my_progress,       presence: true
    validates :opponent_progress, presence: true
  end

  def self.additional_attr_symbols
    [
      :my_height, :opponent_height,
      :judge, :judge_to_me, :judge_to_opponent,
      :progress, :my_progress, :opponent_progress
    ]
  end

  def self.attr_syms_for_params
    s = super()
    s.concat( additional_attr_symbols )
  end

  # SRP(Single Responsibility Principle, 単一責任原則)に従っていないが
  # このクラス内で実装する。
  def self.compose_properties(hash:)
    a = []
    a.push(%Q["score":"#{hash[:my_height]}-#{hash[:opponent_height]}"]) if
      not hash[:my_height].blank? and not hash[:opponent_height].blank?
    a.push(%Q["judge":"#{hash[:judge_to_me]}-#{hash[:judge_to_opponent]}"]) if
      not hash[:judge_to_me].blank? and not hash[:judge_to_opponent].blank?
    a.push(%Q["progress":"#{hash[:my_progress]}-#{hash[:opponent_progress]}"]) if
      not hash[:my_progress].blank? and not hash[:opponent_progress].blank?
    j = ''
    for i in a
      j += ',' if not j.blank?
      j += i
    end
    '{' + j + '}'
  end

  # SRP(Single Responsibility Principle, 単一責任原則)に従っていないが
  # このクラス内で実装する。
  def decompose_properties
    logger.debug(">>>> porperties: #{self.properties}")
    h = JSON.parse(self.properties)
    self.my_height =
      h["score"].to_s.split(/-/)[0] if not h["score"].blank?
    self.opponent_height =
      h["score"].to_s.split(/-/)[1] if not h["score"].blank?
    self.judge = h["judge"].blank? ? false : true
    self.judge_to_me =
      h["judge"].to_s.split(/-/)[0] if not h["judge"].blank?
    self.judge_to_opponent =
      h["judge"].to_s.split(/-/)[1] if not h["judge"].blank?
    self.my_progress =
      h["progress"].to_s.split(/-/)[0] if not h["progress"].blank?
    self.opponent_progress =
      h["progress"].to_s.split(/-/)[1] if not h["progress"].blank?
  end
end
