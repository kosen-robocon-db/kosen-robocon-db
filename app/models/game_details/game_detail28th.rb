class GameDetail28th < GameDetail
  # 得点
  #   先ず自陣のポールエリア3本に輪を掛けないと他のポールに輪を掛けられない
  #   全てのポールに輪をかければその時点でVゴール勝ち
  #   ポール1本掛ければ1点だが中央のポールは2本掛けると5点、3本掛けると10点が得られる。
  #   得点の種類は次の通り：
  #     自陣ポール 1点のみ　三本
  #     中央ポール 1点、5点（二本掛け）、10点（三本掛け）　三本
  #     相手陣ポール 1点のみ　三本
  #   細かく記録したいところだが、Vゴールが多いのと大量得点の二本掛け、三本掛けを
  #   記録するに留める。（Vゴールリーチの8点か二本掛けの8点か区別できればよい。）
  #   最多得点は長野AのC-RAZairで22点
  # リペア
  #   何回まで？リトライではない。
  # 反則
  #   観客席に輪が飛び込んでしまうと反則、そして即失格。
  #   失格時の時間も記録したいが、番組などで確認できないため、実装せず。
  # 審査員判定
  #   同点の場合審査員の挙げた札が多い方が勝ち（地区3名、全国？名）
  # 輪の装填回数
  #   記録したいところだが・・・記録しよう。

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code gaining_point double_pole triple_pole special_win
    time_minute time_second loading retry foul jury_votes )

  REX_GPT = /\A([1-2]{,1}[0-9]|#{UNKNOWN})\z/
  REX_2P  = /\A([0-3]|#{UNKNOWN})\z/
  REX_3P  = /\A([0-3]|#{UNKNOWN})\z/
  REX_LD  = /\A([0-9]|#{UNKNOWN})\z/
  REX_RT  = /\A([0-9]|#{UNKNOWN})\z/
  REX_F   = /\A([0-9]|#{UNKNOWN})\z/
  REX_VT  = /\A([0-5]|#{UNKNOWN})\z/

  # Vホールのように条件を満足すれば即勝利となったときの試合決着時間は
  # special_time_minute/secondとはせず、time_minute/secondとして
  # 他の試合決着時間を記録する大会の変数名と合わせている。
  attr_accessor :my_gaining_point, :opponent_gaining_point
  attr_accessor :my_double_pole,   :opponent_double_pole
  attr_accessor :my_triple_pole,   :opponent_triple_pole
  attr_accessor :my_special_win,   :opponent_special_win
  attr_accessor :my_time_minute,   :opponent_time_minute
  attr_accessor :my_time_second,   :opponent_time_second
  attr_accessor :my_loading,       :opponent_loading
  attr_accessor :my_retry,         :opponent_retry
  attr_accessor :my_foul,          :opponent_foul
  attr_accessor :jury_votes
  attr_accessor :my_jury_votes,    :opponent_jury_votes
  attr_accessor :memo

  validates :my_gaining_point,       format: { with: REX_GPT }
  validates :opponent_gaining_point, format: { with: REX_GPT }
  validates :my_double_pole,         format: { with: REX_2P }
  validates :opponent_double_pole,   format: { with: REX_2P }
  validates :my_triple_pole,         format: { with: REX_3P }
  validates :opponent_triple_pole,   format: { with: REX_3P }
  validates :my_special_win,       inclusion: { in: [ "true", "false", nil ] }
  validates :opponent_special_win, inclusion: { in: [ "true", "false", nil ] }
  validates :my_time_minute,         format: { with: REX_MS }
  validates :opponent_time_minute,   format: { with: REX_MS }
  validates :my_time_second,         format: { with: REX_MS }
  validates :opponent_time_second,   format: { with: REX_MS }
  validates :my_loading,             format: { with: REX_LD }
  validates :opponent_loading,       format: { with: REX_LD }
  validates :my_retry,               format: { with: REX_RT }
  validates :opponent_retry,         format: { with: REX_RT }
  validates :my_foul,                format: { with: REX_F }
  validates :opponent_foul,          format: { with: REX_F }
  with_options if: :jury_votes do
    validates :my_jury_votes,        format: { with: REX_VT }
    validates :opponent_jury_votes,  format: { with: REX_VT }
  end
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_gaining_point, :opponent_gaining_point,
      :my_double_pole,   :opponent_double_pole,
      :my_triple_pole,   :opponent_triple_pole,
      :my_special_win,   :opponent_special_win,
      :my_time_minute,   :opponent_time_minute,
      :my_time_second,   :opponent_time_second,
      :my_loading,       :opponent_loading,
      :my_retry,         :opponent_retry,
      :my_foul,          :opponent_foul,
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
    h = compose_pairs(hash: hash, stems: %w( robot_code gaining_point
      double_pole triple_pole special_win ))
    h.update(compose_time(hash: hash))
    h.update(compose_pairs(hash: hash,
      stems: %w( loading retry foul jury_votes )))
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
      if h["double_pole"].present?
        self.my_double_pole, self.opponent_double_pole =
          h["double_pole"].to_s.split(DELIMITER)
      end
      if h["triple_pole"].present?
        self.my_triple_pole, self.opponent_triple_pole =
          h["triple_pole"].to_s.split(DELIMITER)
      end
      if h["special_win"].present?
        self.my_special_win, self.opponent_special_win =
          h["special_win"].to_s.split(DELIMITER).map{ |x| x.to_bool }
      end
      if h["time"].present? then
        self.my_time_minute, self.my_time_second,
          self.opponent_time_minute, self.opponent_time_second =
            h["time"].to_s.split(DELIMITER_TIME_PAIR)
      end
      if h["loading"].present? then
        self.my_loading, self.opponent_loading =
          h["loading"].to_s.split(DELIMITER)
      end
      if h["retry"].present?
        self.my_retry, self.opponent_retry =
          h["retry"].to_s.split(DELIMITER)
      end
      if h["foul"].present?
        self.my_foul, self.opponent_foul =
          h["foul"].to_s.split(DELIMITER)
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
