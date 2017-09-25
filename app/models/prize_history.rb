class PrizeHistory < ApplicationRecord
  belongs_to :contest, foreign_key: :contest_nth, primary_key: :nth
  belongs_to :region,  foreign_key: :region_code, primary_key: :code
  belongs_to :campus,  foreign_key: :campus_code, primary_key: :code
  belongs_to :robot,   foreign_key: :robot_code,  primary_key: :code
  belongs_to :prize,   foreign_key: :prize_kind,  primary_key: :kind

  validates :contest_nth, presence: true
  validates :region_code, presence: true
  validates :campus_code, presence: true
  validates :robot_code,  presence: true
  validates :prize_kind,  presence: true

  scope :order_default, -> { order("contest_nth asc") }

  def self.csv_headers
    # UTF-8出力される
    [ "大会回", "地区コード", "キャンパスコード", "ロボットコード", "受賞コード" ]
  end

  def self.csv_column_syms
    [ :contest_nth, :region_code, :campus_code, :robot_code, :prize_kind ]
  end
end
