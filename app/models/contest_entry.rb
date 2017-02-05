class ContestEntry < ApplicationRecord
  belongs_to :contest, foreign_key: :nth, primary_key: :nth

  scope :on_page, -> page { paginate(page: page, per_page: 50) }
  scope :order_default, -> { order("nth asc") }
end
