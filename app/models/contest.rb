class Contest < ApplicationRecord
  has_many :robot, dependent: :destroy

  #==validates

  validates :name, presence: true, length:{ maximum:255 }
  validates :nth,  presence: true, uniqueness: true
  validates :year, presence: true

end
