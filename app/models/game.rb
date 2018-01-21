class Game < ApplicationRecord
  module Constant
    NO_OPPONENT = Robot.new(
      code: 100000001, contest_nth: 0, campus_code: 0,
      name: "対戦相手なし", kana: "タイセンアイテナシ"
    ).freeze
    NO_WINNER = Robot.new(
      code: 100000002, contest_nth: 0, campus_code: 0,
      name: "勝者なし", kana: "ショウシャナシ"
    ).freeze # 「両者失格」が相応しいがDBテーブルに登録するコードは勝者なしの意味
    WIN = '1'.freeze # 勝ち         滅多に増えることはないと見積もり、
    LOSE = '2'.freeze # 負け        またDBに保存されることがないので、
    SOLO = '3'.freeze # 単独競技     freezeさせた定数として扱う
    BOTH_DSQ = '4'.freeze # 両者失格
  end
  Constant.freeze # 定数への再代入を防ぐためにモジュールに対してフリーズを実施

  # 試合途中棄権をretireとすべきところを、
  # 第1回はレースであった、そして度々レースがあったので、
  # レースなどでよく使われているDNFにし、
  # それに合わせて試合前棄権をDNS、失格をDSQとした。
  # 1,2,3,...などの数値の代わりに日本語テキスト表示をするために
  # enum_help(GEM)をインストールし（必須）、
  # kosen-robocon.ja.ymlに日本語テキストを記している。
  enum reasons: {
    unearned_win: 1, # 不戦勝
    draw: 2,         # 引き分け（審査員判定・推薦で勝ち負け）
    DNS: 3,          # Do Not Start 負け側が試合開始前棄権
    DNF: 4,          # Do Not Finish 負け側が試合途中棄権
    DSQ: 5,          # Disqualification 負け側が失格　
  }

  before_validation :compose_attributes

  belongs_to :contest, foreign_key: :contest_nth,       primary_key: :nth
  belongs_to :region,  foreign_key: :region_code,       primary_key: :code
  belongs_to :robot,   foreign_key: :left_robot_code,   primary_key: :code
  belongs_to :robot,   foreign_key: :right_robot_code,  primary_key: :code
  belongs_to :robot,   foreign_key: :winner_robot_code, primary_key: :code

  validates :code,              presence: true, uniqueness: true
  validates :contest_nth,       presence: true
  validates :region_code,       presence: true
  validates :round,             presence: true
  validates :game,              presence: true
  validates :left_robot_code,   presence: true
  validates :right_robot_code,  presence: true
  validates :winner_robot_code, presence: true

  attr_accessor :robot_code, :opponent_robot_code, :victory
  validates :victory, inclusion: { in: [
    Constant::WIN, Constant::LOSE, Constant::SOLO, Constant::BOTH_DSQ
  ] }

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
    # if self.winner_robot_code != Constant::NO_WINNER.code
    #   self.victory = self.robot_code == self.winner_robot_code ?
    #     Constant::WIN : Constant::LOSE
    # else
    #   self.victory = Constant::BOTH_DSQ
    # end
    # compose_attributesにある処理と逆処理なのでハッシュ関数化して
    # 両方とも簡単にできないだろうか？
    case self.winner_robot_code
    when Constant::NO_WINNER.code then
      case self.opponent_robot_code
      when Constant::NO_OPPONENT.code then
        logger.debug(">>>> subjective_view_by:NO_WINNER, NO_OPPONENT")
        self.victory = Constant::SOLO
      else
        logger.debug(">>>> subjective_view_by:NO_WINNER")
        self.victory = Constant::BOTH_DSQ
      end
    else
      if self.robot_code == self.winner_robot_code then
        logger.debug(">>>> subjective_view_by: robot(my) = winner")
        self.victory = Constant::WIN
      else
        logger.debug(">>>> subjective_view_by: opponent = winner")
        self.victory = Constant::LOSE
      end
    end
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

  # 特別な#to_csvをオーバーライド
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
    # if self.victory != Constant::BOTH_DSQ
    #   self.winner_robot_code =
    #     self.victory == Constant::WIN ? self.robot_code : self.opponent_robot_code
    # else
    #   self.winner_robot_code = Constant::NO_WINNER.code
    # end
    logger.debug(">>>> compose_attributes, self.victory:#{self.victory}")
    case self.victory
    when Constant::WIN then
      logger.debug(">>>> compose_attributes:WIN")
      self.winner_robot_code = self.robot_code
    when Constant::LOSE then
      logger.debug(">>>> compose_attributes:LOSE")
      self.winner_robot_code = self.opponent_robot_code
    when Constant::SOLO then
      logger.debug(">>>> compose_attributes:SOLO")
      self.right_robot_code  = Constant::NO_OPPONENT.code
      self.winner_robot_code = Constant::NO_WINNER.code
    when Constant::BOTH_DSQ then
      logger.debug(">>>> compose_attributes:BOTH_DSQ")
      self.winner_robot_code = Constant::NO_WINNER.code
    else
      logger.debug(">>>> compose_attributes:else")
      self.winner_robot_code = Constant::NO_WINNER.code
    end
    logger.debug(">>>> compose_attributes, #{self.opponent_robot_code}, #{self.winner_robot_code}")
  end

end
