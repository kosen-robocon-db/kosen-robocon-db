class PrizeType < ApplicationRecord
  has_many :prize, foreign_key: :prize_type, primary_key: :type, dependent: :destroy

  validates :type, presence: true, uniqueness: true
  validates :name, presence: true, length:{ maximum:255 }
end
