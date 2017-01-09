class ContestEntry < ApplicationRecord
  belongs_to :contest

  scope :on_page, -> page { paginate(page: page, per_page: 50) }
  scope :order_default, -> { order("contest_id asc") }
end
