class Game < ApplicationRecord
  before_validation :compose_attributes

  belongs_to :contest,      foreign_key: :contest_nth,       primary_key: :nth
  belongs_to :region,       foreign_key: :region_code,       primary_key: :code
  belongs_to :robot,        foreign_key: :left_robot_code,   primary_key: :code
  belongs_to :robot,        foreign_key: :right_robot_code,  primary_key: :code
  belongs_to :robot,        foreign_key: :winner_robot_code, primary_key: :code
  has_many   :game_details, foreign_key: :game_code,         primary_key: :code,
    dependent: :destroy, inverse_of: :game
  accepts_nested_attributes_for :game_details, allow_destroy: true,
      reject_if: :all_blank

  validates :code,              presence: true, uniqueness: true
  validates :contest_nth,       presence: true
  validates :region_code,       presence: true
  validates :round,             presence: true
  validates :game,              presence: true
  validates :left_robot_code,   presence: true
  validates :right_robot_code,  presence: true
  validates :winner_robot_code, presence: true

  attr_accessor :robot_code, :opponent_robot_code, :victory
  validates :victory, inclusion: { in: ["true", "false"] }

  def self.confirm_or_associate(game_details_sub_class_sym:)
    sym = game_details_sub_class_sym # 変数名が長すぎるのでコピー
    if self.reflect_on_all_associations(:has_many).none? { |i| i.name == sym }
      # Game クラスに関連付けされていないときだけ GameDeital* クラスを関連付け
      self.send( :has_many, sym, foreign_key: :game_code, primary_key: :code,
        dependent: :destroy )
      self.send( :accepts_nested_attributes_for, sym, allow_destroy: true,
        reject_if: :all_blank )
    end
  end

  def self.get_code(hash:)
    if
      not hash[:contest_nth].blank? and
      not hash[:region_code].blank? and
      not hash[:round].blank? and
      not hash[:game].blank?
    then
      "1" + ("%02d" % hash[:contest_nth]) + hash[:region_code].to_s +
      hash[:round].to_s + ("%02d" % hash[:game])
    else
      nil
    end
  end

  def subjective_view_by(robot_code:)
    self.robot_code = robot_code
    self.opponent_robot_code = self.robot_code == self.left_robot_code ?
      self.right_robot_code : self.left_robot_code
    self.victory = self.robot_code == self.winner_robot_code ? "true" : "false"
  end

  private

  def compose_attributes
    self.left_robot_code = self.robot_code
    self.right_robot_code = self.opponent_robot_code
    self.winner_robot_code = self.victory == "true" ? self.robot_code :
      self.opponent_robot_code
  end

end
