class Region < ApplicationRecord
  has_many :campuses, foreign_key: :region_code, primary_key: :code, dependent: :destroy 

  #==validates

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true, length:{ maximum:255 }

end
