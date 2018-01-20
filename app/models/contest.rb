class Contest < ApplicationRecord
  module Constant
    NO_CONTEST = Contest.new(
      nth: 0, year: 0, name: "大会なし"
    ).freeze
  end
  Constant.freeze # 定数への再代入を防ぐためにモジュールに対してフリーズを実施

  has_many :robots, foreign_key: :contest_nth, primary_key: :nth, dependent: :destroy
  has_one :contest_entry, foreign_key: :nth, primary_key: :nth

  #==validates

  validates :name, presence: true, length:{ maximum:255 }
  validates :nth,  presence: true, uniqueness: true
  validates :year, presence: true

  #== scopes

  scope :on_page, -> page { paginate(page: page, per_page: 50) }
  scope :order_default, -> { order("nth desc") }
  scope :without_no_contest, -> { where.not(nth: Constant::NO_CONTEST.nth) }
end
