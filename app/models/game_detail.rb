class GameDetail < ApplicationRecord
  belongs_to :game, foreign_key: :game_code, primary_key: :code
  serialize :properties, JSON
end
