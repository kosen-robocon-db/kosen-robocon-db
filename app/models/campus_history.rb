class CampusHistory < ApplicationRecord
  belongs_to :campus, foreign_key: :campus_code, primary_key: :code
  belongs_to :region, foreign_key: :region_code, primary_key: :code

  #==validates

  validates :campus_code,  presence: true, uniqueness: true
  validates :begin,        presence: true
  validates :end,          presence: true
  validates :name,         presence: true, length:{ maximum:255 }
  validates :abbreviation, presence: true, length:{ maximum:255 }

  scope :order_default, -> { order("begin asc") }
end
