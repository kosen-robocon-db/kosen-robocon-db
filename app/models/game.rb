class Game < ApplicationRecord
  belongs_to :contest,     foreign_key: :contest_nth,       primary_key: :nth
  belongs_to :region,      foreign_key: :region_code,       primary_key: :code
  belongs_to :robot,       foreign_key: :left_robot_code,   primary_key: :code
  belongs_to :robot,       foreign_key: :right_robot_code,  primary_key: :code
  belongs_to :robot,       foreign_key: :winner_robot_code, primary_key: :code
  has_one    :game_detail, foreign_key: :game_code,         primary_key: :code, dependent: :destroy

  validates :code,              presence: true, uniqueness: true
  validates :contest_nth,       presence: true
  validates :region_code,       presence: true
  validates :round,             presence: true
  validates :game,              presence: true
  validates :left_robot_code,   presence: true
  validates :right_robot_code,  presence: true
  validates :winner_robot_code, presence: true

  def self.make_game_code(nth, region_code, round, game)
    #"1" + ("%02d" % nth) + region_code.to_s + round.to_s + ("%02d" % game)
    "1" + nth.rjust(2, "0") + region_code + round + game.rjust(2, "0")
  end
end

class GameForm
  include ActiveModel::Model

  attr_accessor :contest_nth, :region_code, :round, :game,
    :opponent_robot_code, :victory, :new_record, :persisted

  def persisted?
    persisted
  end
end
