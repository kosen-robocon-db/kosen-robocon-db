class GameDetail < ApplicationRecord
  module Constant
    UNKNOWN_VALUE = "__"
  end

  ROOTS          = %w()
  DELIMITER      = "-"
  DELIMITER_TIME = ":"
  REX_MS         = /([0-5][0-9]|#{Constant::UNKNOWN_VALUE})/

  serialize :properties, JSON
  after_initialize :reset_swap_state

  # number は試合詳細の相対的な順番を表す。
  # 例えば、number1 < number2 であれば number2 が再試合である。
  # 更新時に number1 が削除された場合、number2 はそのまま DB に記録される。
  # 将来の機能によっては最初の大戦は全て'1'とするべきだろう。
  # number を含めた UNIQUE index を作るべき

  attr_accessor :my_robot_code, :opponent_robot_code, :victory

  scope :order_default, -> { order("number asc") }
  scope :order_csv, -> { order(id: :asc) }

  def self.additional_attr_symbols
    []
  end

  def self.attr_syms_for_params
    s = [ :id, :number, :_destroy ]
    s.concat( additional_attr_symbols )
  end

  def self.csv_headers
    # UTF-8出力される
    [ "試合コード", "試合番号（再試合）", "属性(JSON)" ]
  end

  def self.csv_column_syms
    [ :game_code, :number, :properties ]
  end

  def self.compose_properties(hash:)
    if hash[:my_robot_code].present? and hash[:opponent_robot_code].present?
      { "robot" => "#{hash[:my_robot_code]}-#{hash[:opponent_robot_code]}" }
    end
  end

  def roots
    ROOTS
  end

  def decompose_properties(robot:)
    h = JSON.parse(self.properties)
    if h["robot"].present? then # 必ずrobotのコードがある前提だが・・・
      self.my_robot_code, self.opponent_robot_code =
        h["robot"].to_s.split(DELIMITER)
    end
    yield h
    swap_properties(roots) unless robot.code.to_i == self.my_robot_code.to_i
  end

  def swap_properties(attribute_roots = %w(robot_code))
    attribute_roots.each do |r|
      # a,b = b,a が可能ではないので、変数を一つ使用して実装
      b = self.send("my_#{r}")
      self.send("my_#{r}=", self.send("opponent_#{r}"))
      self.send("opponent_#{r}=", b)
    end
    @swapped = true
  end

  private

  # 更新時、left_robot_codeとright_robot_codeの内容（位置ではない）に変化がなければ
  # 更新前のleft_robot_codeとright_robot_code、及びproperties内の左右の位置のままで
  # 値だけを更新したかったが、その実装をしなくてもいまのところ害はないので、
  # propertiesの左右交換したことを示す状態フラグを実装するに留めている。
  def reset_swap_state
    @swapped = false
  end

end
