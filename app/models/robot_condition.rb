class RobotCondition < ApplicationRecord
  belongs_to :robot, foreign_key: :robot_code, primary_key: :code

  validates :robot_code,        presence: true #, uniqueness: true
  validates :fully_operational, inclusion: { in: [true, false] }
  validates :restoration,       inclusion: { in: [true, false] }
end
