class Campus < ApplicationRecord
  belongs_to :region
  has_many :robots, dependent: :destroy

  #==validates

  validates :region_id,    presence: true
  validates :name,         presence: true, length:{ maximum:255 }
  validates :abbreviation, presence: true, length:{ maximum:255 }

  #== scopes

  scope :on_page, -> page { paginate(page: page, per_page: 50) }
  scope :order_default, -> { order(:id) }
end
