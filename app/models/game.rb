class Game < ApplicationRecord
  module Constant
    NO_OPPONENT = Robot.new(
      code: 100000000,
      contest_nth: 0,
      campus_code: 0,
      team: "",
      name: "対戦相手なし",
      kana: "タイセンアイテナシ"
    ).freeze
  end
  Constant.freeze # 定数への再代入を防ぐためにモジュールに対してフリーズを実施

  before_validation :compose_attributes

  belongs_to :contest,      foreign_key: :contest_nth,       primary_key: :nth
  belongs_to :region,       foreign_key: :region_code,       primary_key: :code
  belongs_to :robot,        foreign_key: :left_robot_code,   primary_key: :code
  belongs_to :robot,        foreign_key: :right_robot_code,  primary_key: :code
  belongs_to :robot,        foreign_key: :winner_robot_code, primary_key: :code

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

  scope :order_csv, -> { order(id: :asc) }

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

  def self.csv_headers
    # UTF-8出力される
    # 「勝敗事由コード」としているが、勝敗事由が固まり次第、
    # 「不戦勝」や「失格」などを分解し、１ビットまたは１バイトのカラムに変更すべき。
    # 現在は増えて変更が容易いように整数値に変換して格納している。
    # 1 1 1 1 1 b = 31 = 0x1F, ex. 5なら試合前棄権があって不戦勝
    # | | | | |__"不戦勝"
    # | | | |____"引き分け（審査員判定/推薦）"
    # | | |______"試合開始前棄権"
    # | |________"試合途中棄権"
    # |__________"失格"
    [
      "試合コード", "大会回", "地区コード", "回戦", "試合",
      "ロボットコード（左）", "ロボットコード（右）", "勝利ロボットコード",
      "勝敗事由コード"
    ]
  end

  def self.csv_column_syms
    [
      :code, :contest_nth, :region_code, :round, :game,
      :left_robot_code, :right_robot_code, :winner_robot_code,
      :reasons_for_victory
    ]
  end

  def self.convert(array=[])
    a = 0 # ゼロは事由なし
    array.each { |v| a += 2 ** ( v.to_i - 1 ) if v =~ /\A[1-9][0-9]*\z/ }
    a
  end

  # reasons_for_victoryのセッターをオーバーライド
  def reasons_for_victory=(array=[])
    # a = 0 # ゼロは事由なし
    # array.each { |v| a += 2 ** ( v.to_i - 1 ) if v =~ /\A[1-9][0-9]*\z/ }
    write_attribute(:reasons_for_victory, Game.convert(array))
  end

  # reasons_for_victoryのゲッターをオーバーライド
  def reasons_for_victory
    a = Array.new
    r = read_attribute(:reasons_for_victory)
    if r.presence
      s = r.to_s(2)
      s.split(//).each_with_index do |v, i|
        a.push((s.length - i).to_s) if v =~ /\A1\z/
      end
    end
    a
  end

  # Game(試合情報)だけ特別な#to_csvをオーバーライド
  def self.to_csv(options = {})
    CSV.generate(headers: true, force_quotes: true) do |csv|
      csv << csv_headers
      all.each do |record|
        csv << csv_column_syms.map do |attr|
          if attr != :reasons_for_victory
            "#{record.send(attr).to_s}"
          else
            "#{convert(record.reasons_for_victory)}"
          end
        end
      end
    end
  end

  private

  def compose_attributes
    self.left_robot_code = self.robot_code
    self.right_robot_code = self.opponent_robot_code
    self.winner_robot_code = self.victory == "true" ? self.robot_code :
      self.opponent_robot_code
  end

end
