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
      only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5
    }
    validates :judge_to_opponent, numericality: {
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

    # 高さまたは審査委員判定より、値をそのままか交換を決定（優勢な方を先に配置）
    if hash[:my_height] < hash[:opponent_height] ||
      hash[:judge_to_me] < hash[:judge_to_opponent] then
      hash[:my_height], hash[:opponent_height] =
        hash[:opponent_height], hash[:my_height]
      hash[:judge_to_me], hash[:judge_to_opponent] =
        hash[:judge_to_opponent], hash[:judge_to_me]
      hash[:my_progress], hash[:opponent_progress] =
        hash[:opponent_progress], hash[:my_progress]
    end

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
  def decompose_properties(victory)
    h = JSON.parse(self.properties)

    self.my_height, self.opponent_height =
      h["score"].to_s.split(/-/) if not h["score"].blank?
    self.judge = h["judge"].blank? ? false : true
    self.judge_to_me, self.judge_to_opponent =
      h["judge"].to_s.split(/-/) if not h["judge"].blank?
    self.progress = h["progress"].blank? ? false : true
    self.my_progress, self.opponent_progress =
      h["progress"].to_s.split(/-/) if not h["progress"].blank?

    # 勝敗と高さまたは審査委員判定より、値をそのままか交換を決定
    case victory
    when "true"
      swap_properties if self.my_height < self.opponent_height ||
        self.judge_to_me < self.judge_to_opponent
    when "false"
      swap_properties if self.my_height > self.opponent_height ||
        self.judge_to_me > self.judge_to_opponent
    end
  end

  private

  def swap_properties
    self.my_height, self.opponent_height =
      self.opponent_height, self.my_height
    self.judge_to_me, self.judge_to_opponent =
      self.judge_to_opponent, self.judge_to_me
    self.my_progress, self.opponent_progress =
      self.opponent_progress, self.my_progress
  end
end
