class GameDetail < ApplicationRecord
  serialize :properties, JSON

  # number は試合詳細の相対的な順番を表す。
  # 例えば、number1 < number2 であれば number2 が再試合である。
  # 更新時に number1 が削除された場合、number2 はそのまま DB に記録される。
  # 将来の機能によっては最初の大戦は全て'1'とするべきだろう。
  scope :order_default, -> { order("number asc") }
  scope :order_csv, -> { order(id: :asc) }

  def self.attr_syms_for_params
    [ :id, :_destroy ]
  end

  def self.csv_headers
    # UTF-8出力される
    [ "試合コード", "試合番号（再試合）", "属性(JSON)" ]
  end

  def self.csv_column_syms
    [ :game_code, :number, :properties ]
  end

end
