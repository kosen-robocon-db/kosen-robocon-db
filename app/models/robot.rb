class Robot < ApplicationRecord
  belongs_to :contest,         foreign_key: :contest_nth, primary_key: :nth
  belongs_to :campus,          foreign_key: :campus_code, primary_key: :code
  has_one    :robot_condition, foreign_key: :robot_code,  primary_key: :code
  has_many   :prize_histories, foreign_key: :robot_code,  primary_key: :code,
    dependent: :destroy
  #accepts_nested_attributes_for :prize_histories

  #==validates

  validates :code,        presence: true, uniqueness: true
  validates :contest_nth, presence: true
  validates :campus_code, presence: true
  validates :team, allow_blank: true, length:{ maximum:255 }, format: { :with => /(A|B)/i }
  validates :name,                    length:{ maximum:255 }, presence: true
  validates :kana, allow_blank: true, length:{ maximum:255 }

  #== scopes

  scope :on_page, -> page { paginate(page: page, per_page: 60) }
  scope :order_default, -> { order("contest_nth asc, campus_code asc, team asc") }

  def self.team_choices
    [["分からないまたはAB区別なし",""],["Ａチーム","A"],["Ｂチーム","B"]]
  end

  def to_key
    ["#{code}"]
  end

  def to_param
    "#{code}"
  end
end
