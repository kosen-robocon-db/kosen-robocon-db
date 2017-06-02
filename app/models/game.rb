class Game < ApplicationRecord
  before_validation :make_attributes_to_db
  # after_find        :make_attributes_from_db, on: [ :edit, :update ]

  belongs_to :contest,     foreign_key: :contest_nth,       primary_key: :nth
  belongs_to :region,      foreign_key: :region_code,       primary_key: :code
  belongs_to :robot,       foreign_key: :left_robot_code,   primary_key: :code
  belongs_to :robot,       foreign_key: :right_robot_code,  primary_key: :code
  belongs_to :robot,       foreign_key: :winner_robot_code, primary_key: :code
  has_one    :game_detail, foreign_key: :game_code,         primary_key: :code,
    dependent: :destroy
  accepts_nested_attributes_for :game_detail

  validates :code,              presence: true, uniqueness: true
  validates :contest_nth,       presence: true
  validates :region_code,       presence: true
  validates :round,             presence: true
  validates :game,              presence: true
  validates :left_robot_code,   presence: true
  validates :right_robot_code,  presence: true
  validates :winner_robot_code, presence: true

  attr_accessor :robot_code, :opponent_robot_code, :victory
  validates :victory, inclusion: { in: ["true", "false"] }

  private
    def get_code
      "1" + ("%02d" % self.contest_nth) + self.region_code.to_s +
        self.round.to_s + ("%02d" % self.game)
    end

    def make_attributes_to_db
      self.code = get_code
      self.left_robot_code = self.robot_code
      self.right_robot_code = self.opponent_robot_code
      self.winner_robot_code = self.victory == "true" ? self.robot_code :
        self.opponent_robot_code
    end

    def make_attributes_from_db
      # # logger.debug("robot_code : #{self.robot_code}")
      # # logger.debug("left_robot_code : #{self.left_robot_code}")
      # # logger.debug("winner_robot_code : #{self.winner_robot_code}")
      # self.opponent_robot_code = self.robot_code == self.left_robot_code ?
      #   self.right_robot_code : self.left_robot_code
      # self.victory = self.robot_code == self.winner_robot_code ? "true" : "false"
    end
end
