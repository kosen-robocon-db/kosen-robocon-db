class Campus < ApplicationRecord
  module Constant
    NO_CAMPUS = Campus.new(
      code: 0, region_code: 0, name: "キャンパスなし", abbreviation: "キャンパスなし"
    ).freeze
  end
  Constant.freeze # 定数への再代入を防ぐためにモジュールに対してフリーズを実施

  belongs_to :region, foreign_key: :region_code, primary_key: :code
  has_many :robots, foreign_key: :campus_code, primary_key: :code, dependent: :destroy
  has_many :campus_history, foreign_key: :campus_code, primary_key: :code, dependent: :destroy

  #==validates

  validates :code,         presence: true, uniqueness: true
  validates :region_code,  presence: true
  validates :name,         presence: true, length:{ maximum:255 }
  validates :abbreviation, presence: true, length:{ maximum:255 }

  #== scopes

  scope :on_page, -> page { paginate(page: page, per_page: 70) }
  scope :order_default, -> { order("code asc") }
  scope :without_no_campus, -> { where.not(code: Constant::NO_CAMPUS.code) }
end
