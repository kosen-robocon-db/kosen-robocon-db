class GameDetail31st < GameDetail
  # III-2	得点	
  # 〇1 １本のペットボトルを１つのテーブルの上に立てると得点となる。
  # １点：固定テーブル、移動テーブル、２段テーブル下段
  # ５点：２段テーブル上段
  # 〇2 得点の制限
  # a)	固定テーブル・・・１つのテーブルで得られる得点は１点まで（何本立てても１点）
  # b)	移動テーブルおよび２段テーブル下段・・・立てた本数×１が得点となる
  # c)	２段テーブル上段・・・立てた本数×５が得点となる
  # 〇3 得点となるペットボトル
  # 自立していなければならず、支柱や倒れたペットボトルに寄りかかっている状態のものは
  # 得点と認めない。また、一度立っても試合中に倒れてしまったものも得点とならない。
  # III-4	競技の勝敗	
  # ＜予選リーグ＞
  # 競技終了時に得点の高いチームが勝利となる。
  # 同点の場合は以下の順で勝敗を決定する。
  # a）２段テーブル上段の得点が高いチームを勝利とする。
  # b）移動テーブルの得点の合計が高いチームを勝利とする。
  # c）２段テーブル下段の得点が高いチームを勝利とする。
  # d）上記で決定できない場合は審査員判定とする。
  # ＜決勝トーナメント＞
  # a） 先に８か所のテーブルすべてにペットボトルを立てたチームをその時点で勝利（Ｖゴ
  # ール）とする。
  # b） 競技終了時の得点が高いチームの勝利
  # 同点の場合は予選リーグの決定方法に準ずる。
  # 
  # 審査員判定
  #   地区3名、全国5名
  # リトライ
  #   何回でも可能
  #   リトラがが認められてから２０秒間は動けなたため、7回以上はあり得ない。
  # 反則
  #   審判の判断によっては反則の回数に因らず失格となることもある

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code 
    fixed_table1 fixed_table2 fixed_table3 
    double_table_upper double_table_lower 
    movable_table1 movable_table2 movable_table3 
    point retry foul jury_votes )

  UNKNOWN = GameDetail::Constant::UNKNOWN_VALUE

  REX_BL = /\A([0-9]|10|#{UNKNOWN})\z/
  REX_GPT = /\A([1-2]{,1}[0-9]|#{UNKNOWN})\z/
  
  REX_FT  = /\A([1]{,1}[0-9]|20|#{UNKNOWN})\z/
  REX_DTU = /\A([1]{,1}[0-9]|20|#{UNKNOWN})\z/
  REX_DTL = /\A([1]{,1}[0-9]|20|#{UNKNOWN})\z/
  REX_MT  = /\A([1]{,1}[0-9]|20|#{UNKNOWN})\z/
  REX_RP  = /\A([0-9]|#{UNKNOWN})\z/
  REX_F   = /\A([0-9]|#{UNKNOWN})\z/ 
  REX_VT  = /\A([0-5]|#{UNKNOWN})\z/

  attr_accessor :my_fixed_table1,            :opponent_fixed_table1
  attr_accessor :my_fixed_table2,            :opponent_fixed_table2
  attr_accessor :my_fixed_table3,            :opponent_fixed_table3
  attr_accessor :my_double_table_upper,      :opponent_double_table_upper
  attr_accessor :my_double_table_lower,      :opponent_double_table_lower
  attr_accessor :my_movable_table1,          :opponent_movable_table1
  attr_accessor :my_movable_table2,          :opponent_movable_table2
  attr_accessor :my_movable_table3,          :opponent_movable_table3
  attr_accessor :my_point,                   :opponent_point
  attr_accessor :my_retry,                   :opponent_retry
  attr_accessor :my_foul,                    :opponent_foul
  attr_accessor :special_win, :time_minute, :time_second
  attr_accessor :jury_votes, :my_jury_votes, :opponent_jury_votes
  attr_accessor :memo

  validates :my_fixed_table1,             format: { with: REX_FT }
  validates :opponent_fixed_table1,       format: { with: REX_FT }
  validates :my_fixed_table2,             format: { with: REX_FT }
  validates :opponent_fixed_table2,       format: { with: REX_FT }
  validates :my_fixed_table3,             format: { with: REX_FT }
  validates :opponent_fixed_table3,       format: { with: REX_FT }
  validates :my_double_table_upper,       format: { with: REX_DTU }
  validates :opponent_double_table_upper, format: { with: REX_DTU }
  validates :my_double_table_lower,       format: { with: REX_DTL }
  validates :opponent_double_table_lower, format: { with: REX_DTL }
  validates :my_movable_table1,           format: { with: REX_MT }
  validates :opponent_movable_table1,     format: { with: REX_MT }
  validates :my_movable_table2,           format: { with: REX_MT }
  validates :opponent_movable_table2,     format: { with: REX_MT }
  validates :my_movable_table3,           format: { with: REX_MT }
  validates :opponent_movable_table3,     format: { with: REX_MT }
  validates :my_retry,                    format: { with: REX_RP }
  validates :opponent_retry,              format: { with: REX_RP }
  validates :my_foul,                     format: { with: REX_F }
  validates :opponent_foul,               format: { with: REX_F }
  validates :special_win, inclusion: { in: [ "true", "false", nil ] }
  # 両チームのペットボトルが無くなった時点で試合終了となるので、
  # :special_winに依らずにvalidationをさせたほうがよいだろうが、
  # 現状はこのままにしておく。
  with_options if: :special_win do 
    validates :time_minute, format: { with: REX_MS }
    validates :time_second, format: { with: REX_MS }
  end
  with_options if: :jury_votes do
    validates :my_jury_votes,       format: { with: REX_VT }
    validates :opponent_jury_votes, format: { with: REX_VT }
  end
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_fixed_table1,       :opponent_fixed_table1,
      :my_fixed_table2,       :opponent_fixed_table2,
      :my_fixed_table3,       :opponent_fixed_table3,
      :my_double_table_upper, :opponent_double_table_upper,
      :my_double_table_lower, :opponent_double_table_lower,
      :my_movable_table1,     :opponent_movable_table1,
      :my_movable_table2,     :opponent_movable_table2,
      :my_movable_table3,     :opponent_movable_table3,
      :my_point,              :opponent_point,
      :my_retry,              :opponent_retry,
      :my_foul,               :opponent_foul,
      :time_minute, :time_second,
      :special_win,
      :jury_votes,
      :my_jury_votes,         :opponent_jury_votes,
      :memo
    ]
  end

  # 親クラスから子クラスのSTEM定数を参照するためのメソッド
  def stems
    STEMS
  end

  # extra_timeなどのbooleanとnilの三種の値の入力を想定しているフォーム属性変数について
  # trueかfalseかnilかをここで吟味すべきであるが、このproperties生成の後に実行される
  # save/update直前のvalidationによって吟味されるので、有るか無しか(nil)かを吟味する
  # だけにしている。他の数字や文字列が入力される属性も同様である。
  def self.compose_properties(hash:)
 
    h = compose_pairs(hash: hash, stems: STEMS)
    # pointが最後にになってしまうが、応急処置
    h["point"] = "\
      #{hash[:my_point]}\
      #{DELIMITER}\
      #{hash[:opponent_point]}\
    ".gsub(/(\s| )+/, '')
    if hash[:special_win].presence.to_bool
      h["special_win"] = "true"
      h.update(compose_time(hash: hash)) # h["time"]
    end
    h.delete("jury_votes") unless hash["jury_votes"].presence.to_bool
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      # fixed_table{1-3}に対してはもっとよい処ほ方があるはずだ。
      if h["fixed_table1"].present?
        self.my_fixed_table1, self.opponent_fixed_table1 =
          h["fixed_table1"].to_s.split(DELIMITER)
      end
      if h["fixed_table2"].present?
        self.my_fixed_table2, self.opponent_fixed_table2 =
          h["fixed_table2"].to_s.split(DELIMITER)
      end
      if h["fixed_table3"].present?
        self.my_fixed_table3, self.opponent_fixed_table3 =
          h["fixed_table3"].to_s.split(DELIMITER)
      end
      if h["double_table_upper"].present?
        self.my_double_table_upper, self.opponent_double_table_upper =
          h["double_table_upper"].to_s.split(DELIMITER)
      end
      if h["double_table_lower"].present?
        self.my_double_table_lower, self.opponent_double_table_lower =
          h["double_table_lower"].to_s.split(DELIMITER)
      end
      # movable_table{1-3}に対してはもっとよい処理方法があるはずだ。
      if h["movable_table1"].present?
        self.my_movable_table1, self.opponent_movable_table1 =
          h["movable_table1"].to_s.split(DELIMITER)
      end
      if h["movable_table2"].present?
        self.my_movable_table2, self.opponent_movable_table2 =
          h["movable_table2"].to_s.split(DELIMITER)
      end
      if h["movable_table3"].present?
        self.my_movable_table3, self.opponent_movable_table3 =
          h["movable_table3"].to_s.split(DELIMITER)
      end
      if h["point"].present?
        self.my_point, self.opponent_point =
          h["point"].to_s.split(DELIMITER)
      end
      if h["retry"].present?
        self.my_retry, self.opponent_retry =
          h["retry"].to_s.split(DELIMITER)
      end
      if h["foul"].present?
        self.my_foul, self.opponent_foul =
          h["foul"].to_s.split(DELIMITER)
      end
      if h["time"].present?
        self.time_minute, self.time_second =
          h["time"].to_s.split(DELIMITER_TIME)
      end
      if h["special_win"].present?
        self.special_win = true
        self.time_minute, self.time_second =
          h["time"].to_s.split(DELIMITER_TIME)
      end
      if h["jury_votes"].present?
        self.jury_votes = true
        self.my_jury_votes, self.opponent_jury_votes =
          h["jury_votes"].to_s.split(DELIMITER)
      end
      self.memo = h["memo"].presence || ''
    end
  end

end
