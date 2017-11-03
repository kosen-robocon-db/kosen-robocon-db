class AdvancementHistory < ApplicationRecord
  belongs_to :robot,       foreign_key: :robot_code,       primary_key: :code
  belongs_to :advancement, foreign_key: :advancement_case, primary_key: :case

  validates :robot_code,        presence: true #, uniqueness: true
  # validates :decline,           inclusion: { in: [true, false] }

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
