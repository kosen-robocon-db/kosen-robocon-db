class Robot < ApplicationRecord
  belongs_to :contest
  belongs_to :campus

  #==validates

  validates :contest_id, presence: true
  validates :campus_id,  presence: true
  validates :name, allow_blank: true, length:{ maximum:255 }
  validates :kana, allow_blank: true, length:{ maximum:255 }
  validates :team, allow_blank: true, length:{ maximum:255 }, format: { :with => /(A|B)/i }

end
