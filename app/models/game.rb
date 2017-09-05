class Game < ApplicationRecord
  before_validation :make_attributes_to_db
  # after_find        :make_attributes_from_db, on: [ :edit, :update ]
  # after_find は特定のライフサイクルのイベントのみ呼び出されるのは出来ない
  # 参照：https://railsguides.jp/active_record_callbacks.html#after-initialize%E3%81%A8after-find

  belongs_to :contest,      foreign_key: :contest_nth,       primary_key: :nth
  belongs_to :region,       foreign_key: :region_code,       primary_key: :code
  belongs_to :robot,        foreign_key: :left_robot_code,   primary_key: :code
  belongs_to :robot,        foreign_key: :right_robot_code,  primary_key: :code
  belongs_to :robot,        foreign_key: :winner_robot_code, primary_key: :code
  has_many   :game_details, foreign_key: :game_code,         primary_key: :code,
    dependent: :destroy, # 大量削除はなく直接SQLを発行せずともよいので採用
    inverse_of: :game
    # dependent: :delete_all
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

  def self.get_code(h)
    if
      not h[:contest_nth].blank? and
      not h[:region_code].blank? and
      not h[:round].blank? and
      not h[:game].blank?
    then
      "1" + ("%02d" % h[:contest_nth]) + h[:region_code].to_s +
      h[:round].to_s + ("%02d" % h[:game])
    else
      nil
    end
  end

  # def get_code
  #   if
  #     not self.contest_nth.blank? and
  #     not self.region_code.blank? and
  #     not self.round.blank? and
  #     not self.game.blank?
  #   then
  #   "1" + ("%02d" % self.contest_nth) + self.region_code.to_s +
  #     self.round.to_s + ("%02d" % self.game)
  #   else
  #     nil
  #   end
  # end

  def make_attributes_from_db
    self.opponent_robot_code = self.robot_code == self.left_robot_code ?
      self.right_robot_code : self.left_robot_code
    self.victory = self.robot_code == self.winner_robot_code ? "true" : "false"
  end

  private

  def make_attributes_to_db
    # self.code = get_code
    self.left_robot_code = self.robot_code
    self.right_robot_code = self.opponent_robot_code
    self.winner_robot_code = self.victory == "true" ? self.robot_code :
      self.opponent_robot_code
  end

end
