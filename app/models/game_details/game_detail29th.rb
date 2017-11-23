class GameDetail29th < GameDetail
  attr_accessor :my_height, :opponent_height,
    :jury, :my_jury_votes, :opponent_jury_votes,
    :progress, :my_progress, :opponent_progress

  validates :my_height,         numericality: {
    only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 1000
  }
  validates :opponent_height,   numericality: {
    only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 1000
  }
  # validates :jury,             inclusion: { in: ["true", "false"] }
  with_options if: :jury do
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
      :jury, :my_jury_votes, :opponent_jury_votes,
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
    # 存在チェックをしてないので例外が出力される可能性がある
    if hash[:my_height] < hash[:opponent_height] ||
      hash[:my_jury_votes] < hash[:opponent_jury_votes] then
      hash[:my_height], hash[:opponent_height] =
        hash[:opponent_height], hash[:my_height]
      hash[:my_jury_votes], hash[:opponent_jury_votes] =
        hash[:opponent_jury_votes], hash[:my_jury_votes]
      hash[:my_progress], hash[:opponent_progress] =
        hash[:opponent_progress], hash[:my_progress]
    end

    a = []
    a.push(%Q["height":"#{hash[:my_height]}-#{hash[:opponent_height]}"]) if
      not hash[:my_height].blank? and not hash[:opponent_height].blank?
    a.push(%Q["jury":"#{hash[:my_jury_votes]}-#{hash[:opponent_jury_votes]}"]) if
      not hash[:my_jury_votes].blank? and not hash[:opponent_jury_votes].blank?
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
      h["height"].to_s.split(/-/) if not h["height"].blank?
    self.jury = h["jury"].blank? ? false : true
    self.my_jury_votes, self.opponent_jury_votes =
      h["jury"].to_s.split(/-/) if not h["jury"].blank?
    self.progress = h["progress"].blank? ? false : true
    self.my_progress, self.opponent_progress =
      h["progress"].to_s.split(/-/) if not h["progress"].blank?

    # 勝敗と高さまたは審査委員判定より、値をそのままか交換を決定
    case victory
    when "true"
      swap_properties if self.my_height < self.opponent_height ||
        (
          !self.my_jury_votes.blank? && !self.opponent_jury_votes.blank? &&
            self.my_jury_votes < self.opponent_jury_votes
        )
    when "false"
      swap_properties if self.my_height > self.opponent_height ||
        (
          !self.my_jury_votes.blank? && !self.opponent_jury_votes.blank? &&
            self.my_jury_votes > self.opponent_jury_votes
        )
    end
  end

  private

  def swap_properties
    self.my_height, self.opponent_height =
      self.opponent_height, self.my_height
    self.my_jury_votes, self.opponent_jury_votes =
      self.opponent_jury_votes, self.my_jury_votes
    self.my_progress, self.opponent_progress =
      self.opponent_progress, self.my_progress
  end
end
