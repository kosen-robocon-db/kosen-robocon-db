class AdvancementHistory < ApplicationRecord
  belongs_to :contest,     foreign_key: :contest_nth,      primary_key: :nth
  belongs_to :region,      foreign_key: :region_code,      primary_key: :code
  belongs_to :campus,      foreign_key: :campus_code,      primary_key: :code
  belongs_to :robot,       foreign_key: :robot_code,       primary_key: :code
  belongs_to :advancement, foreign_key: :advancement_case, primary_key: :case

  validates :robot_code,        presence: true #, uniqueness: true
  # validates :decline,           inclusion: { in: [true, false] }

  scope :order_default, -> { order(
    contest_nth: :asc,
    region_code: :asc,
    campus_code: :asc,
    robot_code: :asc,
  ) }
  scope :order_csv, -> { order(robot_code: :asc) }

  def self.csv_headers
    # UTF-8出力される
    [
      "回", "地区", "キャンパスコード", "ロボットコード", "進出ケース",
      "辞退", "メモ"
    ]
  end

  def self.csv_column_syms
    [
      :contest_nth, :region_code, :campus_code, :robot_code, :advancement_case,
      :decline, :memo
    ]
  end
end
