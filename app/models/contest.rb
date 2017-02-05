class Contest < ApplicationRecord
  has_many :robots, dependent: :destroy
  has_one :contest_entry, foreign_key: :nth, primary_key: :nth

  #==validates

  validates :name, presence: true, length:{ maximum:255 }
  validates :nth,  presence: true, uniqueness: true
  validates :year, presence: true

  #== scopes

  scope :on_page, -> page { paginate(page: page, per_page: 50) }
  scope :order_default, -> { order("nth desc") }
end
