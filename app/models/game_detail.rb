class GameDetail < ApplicationRecord
  belongs_to :game, foreign_key: :game_code, primary_key: :code
  serialize :properties, JSON

  scope :order_default, -> { order("number asc") }
end
