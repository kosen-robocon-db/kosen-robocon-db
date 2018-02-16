class GameDetail29th < GameDetail
  REX = /-/

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

  def self.additional_attr_symbols
    [
      :my_height, :opponent_height,
      :jury_votes, :my_jury_votes, :opponent_jury_votes,
      :progress, :my_progress, :opponent_progress
    ]
  end

  # SRP(Single Responsibility Principle, 単一責任原則)に従っていないが
  # このクラス内で実装する。
  def self.compose_properties(hash:)
    h = super(hash: hash) || {}
    properties = %w( height jury_votes progress )
    properties.each do |pr|
      my_sym, opponent_sym = "my_#{pr}".to_sym, "opponent_#{pr}".to_sym
      if hash[my_sym].present? and hash[opponent_sym].present?
        h["#{pr}"] = "#{hash[my_sym]}-#{hash[opponent_sym]}"
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
    # ^^^^ 親クラスの上記部分だけyieldのようなもので呼び出せないか？

    self.my_height, self.opponent_height =
      h["height"].to_s.split(REX) if h["height"].present?
    self.jury_votes = h["jury_votes"].present? ? true : false
    self.my_jury_votes, self.opponent_jury_votes =
      h["jury_votes"].to_s.split(REX) if h["jury_votes"].present?
    self.progress = h["progress"].present? ? true : false
    self.my_progress, self.opponent_progress =
      h["progress"].to_s.split(REX) if h["progress"].present?

    # my_robot_code側から見ているので、ロボットコード異なる場合は左右の値を交換する
    roots = %w( robot_code height jury_votes progress)
    # vvvv 親クラスの下記部分だけyieldのようなもので呼び出せないか？
    swap_properties(roots) unless robot.code.to_i == self.my_robot_code.to_i
  end

end
