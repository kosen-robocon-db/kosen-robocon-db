class GameDetail < ApplicationRecord

  # number は試合詳細の相対的な順番を表す。
  # 例えば、number1 < number2 であれば number2 が再試合である。
  # 更新時に number1 が削除された場合、number2 はそのまま DB に記録される。
  # 将来の機能によっては最初の大戦は全て'1'とするべきだろう。
  scope :order_default, -> { order("number asc") }

  def self.attr_syms_for_params
    [ :id, :_destroy ]
  end

end
