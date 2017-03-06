class Campus < ApplicationRecord
  belongs_to :region, foreign_key: :region_code, primary_key: :code
  has_many :robots, foreign_key: :campus_code, primary_key: :code, dependent: :destroy
  has_many :campus_history, foreign_key: :campus_code, primary_key: :code, dependent: :destroy

  #==validates

  validates :code,         presence: true, uniqueness: true
  validates :region_code,  presence: true
  validates :name,         presence: true, length:{ maximum:255 }
  validates :abbreviation, presence: true, length:{ maximum:255 }

  #== scopes

  scope :on_page, -> page { paginate(page: page, per_page: 50) }
  scope :order_default, -> { order("code asc") }
end
