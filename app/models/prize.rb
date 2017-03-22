class Prize < ApplicationRecord
  has_many :prize_history, foreign_key: :prize_kind, primary_key: :kind, dependent: :destroy

  validates :kind, presence: true, uniqueness: true
  validates :name, presence: true, length:{ maximum:255 }
end
