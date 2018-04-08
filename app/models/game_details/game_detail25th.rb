class GameDetail25th < GameDetail
  # 勝敗
  # 　赤い穴に赤のボールを入れて1点、虹色の穴に虹色のボールを入れると4点、
  #   点数の多い方が勝ち。
  #   9つ全ての穴に入れるとパーフェクトで、先にパーフェクトを達成した方が勝ち
  # リトライ
  #   何回まで？
  # 審査員判定
  #   地区3名、全国？名
  # 反則(foul)
  #   反則があれば・・・どうなるの？反則で後ろに下がったチームがあったが
  # 準決勝からレインボーゴールが増えて配置が変る
  # 1回戦は3分間またはパーフェクトするまで試合を続ける。

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code gaining_point time_minute time_second special_win
    foul retry jury_votes )

  REX_GPT = /\A([0-9]|1[0-8]|#{UNKNOWN})\z/
  REX_F   = /\A([0-9]|#{UNKNOWN})\z/
  REX_RT  = /\A([0-9]|#{UNKNOWN})\z/
  REX_VT  = /\A([0-5]|#{UNKNOWN})\z/

  # Vホールのように条件を満足すれば即勝利となったときの試合決着時間は
  # special_time_minute/secondとはせず、time_minute/secondとして
  # 他の試合決着時間を記録する大会の変数名と合わせている。
  attr_accessor :my_gaining_point, :opponent_gaining_point
  attr_accessor :my_special_win,   :opponent_special_win
  attr_accessor :my_time_minute,   :opponent_time_minute
  attr_accessor :my_time_second,   :opponent_time_second
  attr_accessor :my_foul,          :opponent_foul
  attr_accessor :my_retry,         :opponent_retry
  attr_accessor :jury_votes
  attr_accessor :my_jury_votes,    :opponent_jury_votes
  attr_accessor :memo

  validates :my_gaining_point,       format: { with: REX_GPT }
  validates :opponent_gaining_point, format: { with: REX_GPT }
  validates :my_time_minute,         format: { with: REX_MS }
  validates :opponent_time_minute,   format: { with: REX_MS }
  validates :my_time_second,         format: { with: REX_MS }
  validates :opponent_time_second,   format: { with: REX_MS }
  validates :my_special_win,       inclusion: { in: [ "true", "false", nil ] }
  validates :opponent_special_win, inclusion: { in: [ "true", "false", nil ] }
  validates :my_foul,                format: { with: REX_F }
  validates :opponent_foul,          format: { with: REX_F }
  validates :my_retry,               format: { with: REX_RT }
  validates :opponent_retry,         format: { with: REX_RT }
  with_options if: :jury_votes do
    validates :my_jury_votes,        format: { with: REX_VT }
    validates :opponent_jury_votes,  format: { with: REX_VT }
  end
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_gaining_point, :opponent_gaining_point,
      :my_time_minute,   :opponent_time_minute,
      :my_time_second,   :opponent_time_second,
      :my_special_win,   :opponent_special_win,
      :my_foul,          :opponent_foul,
      :my_retry,         :opponent_retry,
      :jury_votes,
      :my_jury_votes,    :opponent_jury_votes,
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
    if # compose_pairsで拾えないspecial_winのケースに対応。どちらも無ければ必要なし。
      hash[:my_special_win].present? and
      hash[:opponent_special_win].blank?
    then
      hash[:opponent_special_win] = "false"
      hash[:opponent_time_minute] = "#{UNKNOWN}"
      hash[:opponent_time_second] = "#{UNKNOWN}"
    end
    if # compose_pairsで拾えないspecial_winのケースに対応。どちらも無ければ必要なし。
      hash[:my_special_win].blank? and
      hash[:opponent_special_win].present?
    then
      hash[:my_special_win] = "false"
      hash[:my_time_minute] = "#{UNKNOWN}"
      hash[:my_time_second] = "#{UNKNOWN}"
    end
    h = compose_pairs(hash: hash,
      stems: %w(robot_code gaining_point special_win foul retry jury_votes))
    h.update(compose_time(hash: hash))
    h.delete("jury_votes") unless hash["jury_votes"].presence.to_bool
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["gaining_point"].present?
        self.my_gaining_point, self.opponent_gaining_point =
          h["gaining_point"].to_s.split(DELIMITER)
      end
      if h["time"].present? then
        self.my_time_minute, self.my_time_second,
          self.opponent_time_minute, self.opponent_time_second =
            h["time"].to_s.split(DELIMITER_TIME_PAIR)
      end
      if h["special_win"].present?
        self.my_special_win, self.opponent_special_win =
          h["special_win"].to_s.split(DELIMITER).map{ |x| x.to_bool }
      end
      if h["foul"].present?
        self.my_foul, self.opponent_foul =
          h["foul"].to_s.split(DELIMITER)
      end
      if h["retry"].present?
        self.my_retry, self.opponent_retry =
          h["retry"].to_s.split(DELIMITER)
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
