class Game < ApplicationRecord
  belongs_to :contest, foreign_key: :contest_nth, primary_key: :nth
  belongs_to :region,  foreign_key: :region_code, primary_key: :code
  belongs_to :robot,   foreign_key: :team_left,   primary_key: :code
  belongs_to :robot,   foreign_key: :team_right,  primary_key: :code
  belongs_to :robot,   foreign_key: :winner_team, primary_key: :code

  validates :code,        presence: true, uniqueness: true
  validates :contest_nth, presence: true
  validates :region_code, presence: true
  validates :round,       presence: true
  validates :game,        presence: true
  validates :team_left,   presence: true
  validates :team_right,  presence: true
  validates :winner_team, presence: true
end
