class GameDetail29th < GameDetail

  VALID_DIGIT_REGEX = /\A[0-9]+\z/

  attr_accessor :my_height, :opponent_height,
    :judge, :judge_to_me, :judge_to_opponent

  # validates :my_height,       presence: true,
  #   length: { in: 1..3 }, format: { with: VALID_DIGIT_REGEX }
  # validates :opponent_height, presence: true,
  #   length: { in: 1..3 }, format: { with: VALID_DIGIT_REGEX }
  # validates :judge_to_me,     presence: true,

  validates :my_height,       presence: true
  validates :opponent_height, presence: true

  # def self.confirm_or_associate(game_class_sym:)
  #   sym = game_class_sym
  #   if self.reflect_on_all_associations(:belongs_to).none? { |i| i.name == sym }
  #     self.send(:belongs_to, sym, foreign_key: :game_code, primary_key: :code)
  #   end
  # end

  def self.additional_attr_symbols
    [
      :my_height, :opponent_height,
      :judge, :judge_to_me, :judge_to_opponent
    ]
  end

  def self.attr_syms_for_params
    s = super()
    s.concat( additional_attr_symbols )
  end

  # SRP(Single Responsibility Principle, 単一責任原則)に従っていないが
  # このクラス内で実装する。
  def self.compose_properties(hash:)
    # %Q[{"score":"#{hash[:my_height]}-#{hash[:opponent_height]}"}]
    a = []
    a.push(%Q["score":"#{hash[:my_height]}-#{hash[:opponent_height]}"]) if
      not hash[:my_height].blank? and not hash[:opponent_height].blank?
    a.push(%Q["judge":"#{hash[:judge_to_me]}-#{hash[:judge_to_opponent]}"]) if
      not hash[:judge_to_me].blank? and not hash[:judge_to_opponent].blank?
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
  end
end
