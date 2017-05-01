class RobotCondition < ApplicationRecord
  belongs_to :robot, foreign_key: :robot_code, primary_key: :code

  validates :robot_code,        presence: true #, uniqueness: true
  validates :fully_operational, inclusion: { in: [true, false] }
  validates :restoration,       inclusion: { in: [true, false] }

  def to_key
    ["#{robot_code}"]
  end

  def to_param
    "#{robot_code}"
  end
end
