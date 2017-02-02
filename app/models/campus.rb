class Campus < ApplicationRecord
  belongs_to :region, foreign_key: :region_code, primary_key: :code
  has_many :robots, dependent: :destroy

  #==validates

  validates :region_code,  presence: true
  validates :code,         presence: true
  validates :name,         presence: true, length:{ maximum:255 }
  validates :abbreviation, presence: true, length:{ maximum:255 }

  #== scopes

  scope :on_page, -> page { paginate(page: page, per_page: 50) }
  scope :order_default, -> { order("code asc") }
end
