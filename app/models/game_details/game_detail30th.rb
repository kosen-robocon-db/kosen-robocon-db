class GameDetail30th < GameDetail
  attr_accessor :my_robot_baloon, :opponent_robot_baloon,
   :my_base_baloon, :opponent_base_baloon,
   :judge, :judge_to_me, :judge_to_opponent,
   :time

  validates :my_robot_baloon, numericality: {
    only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10
  }
  validates :opponent_robot_baloon, numericality: {
    only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10
  }
  validates :my_base_baloon, numericality: {
    only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10
  }
  validates :opponent_base_baloon, numericality: {
    only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10
  }
  # validates :time, numericality: {
  #   only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10
  # }
  with_options if: :judge do
    validates :judge_to_me,       numericality: {
      only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5
    }
    validates :judge_to_opponent, numericality: {
      only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5
    }
  end

  def self.additional_attr_symbols
    [
      :my_robot_baloon, :opponent_robot_baloon,
      :my_base_baloon, :opponent_base_baloon,
      :judge, :judge_to_me, :judge_to_opponent,
      :time
    ]
  end

  def self.attr_syms_for_params
    s = super()
    s.concat( additional_attr_symbols )
  end

  # SRP(Single Responsibility Principle, 単一責任原則)に従っていないが
  # このクラス内で実装する。
  def self.compose_properties(hash:)

    # 風船の数で、値をそのままか交換を決定（優勢な方を先に配置。勝敗は関係ない。）
    # リフクレションでもっと簡潔に書けないか？
    if hash[:my_robot_baloon] < hash[:opponent_robot_baloon] ||
      hash[:my_base_baloon] < hash[:opponent_base_baloon] ||
      hash[:judge_to_me] < hash[:judge_to_opponent] then
      hash[:my_robot_baloon], hash[:opponent_robot_baloon] =
        hash[:opponent_robot_baloon], hash[:my_robot_baloon]
      hash[:my_base_baloon], hash[:opponent_base_baloon] =
        hash[:opponent_base_baloon], hash[:my_base_baloon]
      hash[:judge_to_me], hash[:judge_to_opponent] =
        hash[:judge_to_opponent], hash[:judge_to_me]
    end

    a = []
    a.push(%Q["robot-baloon":"#{hash[:my_robot_baloon]}-#{hash[:opponent_robot_baloon]}"]) if
      not hash[:my_robot_baloon].blank? and not hash[:opponent_robot_baloon].blank?
    a.push(%Q["base-baloon":"#{hash[:my_base_baloon]}-#{hash[:opponent_base_baloon]}"]) if
      not hash[:my_base_baloon].blank? and not hash[:opponent_base_baloon].blank?
    a.push(%Q["time":"#{hash[:time]}"]) if
      not hash[:time].blank?
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
  def decompose_properties(victory)
    h = JSON.parse(self.properties)
    self.my_robot_baloon, self.opponent_robot_baloon =
      h["robot-baloon"].to_s.split(/-/) if not h["robot-baloon"].blank?
    self.my_base_baloon, self.opponent_base_baloon =
      h["base-baloon"].to_s.split(/-/) if not h["base-baloon"].blank?
    self.time =
      h["time"].to_s.split(/-/) if not h["time"].blank?
    self.judge_to_me, self.judge_to_opponent =
      h["judge"].to_s.split(/-/) if not h["judge"].blank?

    # 勝敗と高さまたは審査委員判定より、値をそのままか交換を決定
    case victory
    when "true"
      swap_properties if self.my_robot_baloon < self.opponent_robot_baloon ||
        self.my_base_baloon < self.opponent_base_baloon ||
        self.judge_to_me < self.judge_to_opponent
    when "false"
      swap_properties if self.my_robot_baloon > self.opponent_robot_baloon ||
        self.my_base_baloon > self.opponent_base_baloon ||
        self.judge_to_me > self.judge_to_opponent
    end
  end

  private

  def swap_properties
    self.my_robot_baloon, self.opponent_robot_baloon =
      self.opponent_robot_baloon, self.my_robot_baloon
    self.my_base_baloon, self.opponent_base_baloon =
      self.opponent_base_baloon, self.my_base_baloon
    self.judge_to_me, self.judge_to_opponent =
      self.judge_to_opponent, self.judge_to_me
  end
end
