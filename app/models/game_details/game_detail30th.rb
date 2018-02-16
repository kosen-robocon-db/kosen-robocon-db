class GameDetail30th < GameDetail
  module Constant
    UNKNOWN_VALUE = "__"
    BALOON_MIN = 0
    BALOON_MAX = 10
  end

  REX    = /-/
  REX_BL = /([0-9]|10|#{Constant::UNKNOWN_VALUE})/

  attr_accessor :my_robot_baloon, :opponent_robot_baloon
  attr_accessor :my_base_baloon, :opponent_base_baloon
  attr_accessor :jury_votes, :my_jury_votes, :opponent_jury_votes
  attr_accessor :time

  with_options if: :my_robot_baloon do
    validates :my_robot_baloon, format: { with: REX_BL }
  end
  with_options if: :opponent_robot_baloon do
    validates :opponent_robot_baloon, format: { with: REX_BL }
  end
  with_options if: :my_base_baloon do
    validates :my_base_baloon, format: { with: REX_BL }
  end
  with_options if: :opponent_base_baloon do
    validates :opponent_base_baloon, format: { with: REX_BL }
  end
  # validates :time, numericality: {
  #   only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10
  # }
  # 審査員判定の票に関しては、今回一つもなかったので、改善を施していない。
  with_options if: :jury_votes do
    validates :my_jury_votes,       numericality: {
      only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5
    }
    validates :opponent_jury_votes, numericality: {
      only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5
    }
  end

  def self.additional_attr_symbols
    [
      :my_robot_baloon, :opponent_robot_baloon,
      :my_base_baloon, :opponent_base_baloon,
      :jury_votes, :my_jury_votes, :opponent_jury_votes,
      :time
    ]
  end

  def self.attr_syms_for_params
    s = super() || []
    s.concat( additional_attr_symbols )
  end

  # SRP(Single Responsibility Principle, 単一責任原則)に従っていないが
  # このクラス内で実装する。
  def self.compose_properties(hash:)
    h = super(hash: hash) || {}
    properties = %w( base_baloon robot_baloon jury_votes )
    properties.each do |pr|
      my_sym, opponent_sym = "my_#{pr}".to_sym, "opponent_#{pr}".to_sym
      if hash[my_sym].present? and hash[opponent_sym].present?
        h["#{pr}"] = "#{hash[my_sym]}-#{hash[opponent_sym]}"
      end
    end
    h["time"] = "#{hash[:time]}" if hash[:time].present?
    return h
  end

  # SRP(Single Responsibility Principle, 単一責任原則)に従っていないが
  # このクラス内で実装する。
  def decompose_properties(robot:)
    h = JSON.parse(self.properties)
    if h["robot"].present? then # テーブルカラムにすべきでは？ 必ずコードがある前提
      self.my_robot_code, self.opponent_robot_code = h["robot"].to_s.split(REX)
    end # テーブルカラムにすれば全ての継承クラスで同じコードを書かなくて済むはず！

    self.my_base_baloon, self.opponent_base_baloon =
      h["base_baloon"].to_s.split(REX) if h["base_baloon"].present?
    self.my_robot_baloon, self.opponent_robot_baloon =
      h["robot_baloon"].to_s.split(REX) if h["robot_baloon"].present?
    self.jury_votes = h["jury_votes"].present? ? true : false
    self.my_jury_votes, self.opponent_jury_votes =
      h["jury_votes"].to_s.split(REX) if h["jury_votes"].present?
    self.time = h["time"].to_s if h["time"].present?

    # my_robot_code側から見ているので、ロボットコード異なる場合は左右の値を交換する
    roots = %w( base_baloon robot_baloon jury_votes )
    # vvvv 親クラスの下記部分だけyieldのようなもので呼び出せないか？
    swap_properties(roots) unless robot.code.to_i == self.my_robot_code.to_i
  end

end
