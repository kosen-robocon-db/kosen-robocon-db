class GameDetail < ApplicationRecord
  belongs_to :game, foreign_key: :game_code, primary_key: :code
  serialize :properties, JSON

  scope :order_default, -> { order("number asc") }

  def self.attr_syms_for_params
    [ :id, :_destroy ]
  end

end
