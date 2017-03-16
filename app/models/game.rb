class Game < ApplicationRecord
  belongs_to :contest, foreign_key: :contest_nth,       primary_key: :nth
  belongs_to :region,  foreign_key: :region_code,       primary_key: :code
  belongs_to :robot,   foreign_key: :left_robot_code,   primary_key: :code
  belongs_to :robot,   foreign_key: :right_robot_code,  primary_key: :code
  belongs_to :robot,   foreign_key: :winner_robot_code, primary_key: :code

  validates :code,              presence: true, uniqueness: true
  validates :contest_nth,       presence: true
  validates :region_code,       presence: true
  validates :round,             presence: true
  validates :game,              presence: true
  validates :left_robot_code,   presence: true
  validates :right_robot_code,  presence: true
  validates :winner_robot_code, presence: true
end
