class Region < ApplicationRecord
  has_many :campuses, dependent: :destroy

  #==validates

  validates :name, presence: true, length:{ maximum:255 }

end
