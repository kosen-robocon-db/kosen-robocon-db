class RobotCondition < ApplicationRecord
  belongs_to :robot, foreign_key: :robot_code, primary_key: :code

  validates :robot_code,        presence: true #, uniqueness: true
  validates :fully_operational, inclusion: { in: [true, false] }
  validates :restoration,       inclusion: { in: [true, false] }

  scope :order_csv, -> { order(robot_code: :asc) }

  def to_key
    ["#{robot_code}"]
  end

  def to_param
    "#{robot_code}"
  end

  def self.csv_headers
    # UTF-8出力される
    [ "ロボットコード", "動態保存", "復刻", "メモ" ]
  end

  def self.csv_column_syms
    [ :robot_code, :fully_operational, :restoration, :memo ]
  end
end
