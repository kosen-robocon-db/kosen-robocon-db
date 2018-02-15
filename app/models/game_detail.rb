class GameDetail < ApplicationRecord
  serialize :properties, JSON
  after_initialize :reset_swap_state

  # number は試合詳細の相対的な順番を表す。
  # 例えば、number1 < number2 であれば number2 が再試合である。
  # 更新時に number1 が削除された場合、number2 はそのまま DB に記録される。
  # 将来の機能によっては最初の大戦は全て'1'とするべきだろう。

  attr_accessor :my_robot_code, :opponent_robot_code, :victory

  scope :order_default, -> { order("number asc") }
  scope :order_csv, -> { order(id: :asc) }

  def self.attr_syms_for_params
    [ :id, :number, :_destroy ]
  end

  def self.csv_headers
    # UTF-8出力される
    [ "試合コード", "試合番号（再試合）", "属性(JSON)" ]
  end

  def self.csv_column_syms
    [ :game_code, :number, :properties ]
  end

  def self.compose_properties(hash:)
    logger.debug(">>>> game_detail, compose_properties:#{hash[:my_robot_code]}, #{hash[:opponent_robot_code]}")
    if hash[:my_robot_code].present? and hash[:opponent_robot_code].present?
      { "robot" => "#{hash[:my_robot_code]}-#{hash[:opponent_robot_code]}" }
    end
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

  def reset_swap_state
    @swapped = false
  end

end
