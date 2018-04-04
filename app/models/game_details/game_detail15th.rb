class GameDetail15th < GameDetail

  # リトライ１回のみ
  # 減点あり（箱を落す・壊すなど）
  # 　減点3回で失格
  # 獲得スポット数が同数の場合、高く積んでる方が勝ち
  # 引き分け時は審査員判定。地区3人、全国？人。または1分間の延長？
  #   地区によって異なる？
  # トルネード（15段積み）ができたら即勝ち

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code gaining_point deducting_point total_point retry
    jury_votes )

  REX_GPT = /\A([0-3]|#{UNKNOWN})\z/
  REX_DPT = /\A([0-3]|#{UNKNOWN})\z/
  REX_TPT = /\A(-[1-3]|[0-3]|#{UNKNOWN})\z/
  REX_RT  = /\A([0-1]|#{UNKNOWN})\z/
  REX_VT  = /\A([0-5]|#{UNKNOWN})\z/

  # Vホールのように条件を満足すれば即勝利となったときの試合決着時間は
  # special_time_minute/secondとはせず、time_minute/secondとして
  # 他の試合決着時間を記録する大会の変数名と合わせている。
  attr_accessor :my_gaining_point,   :opponent_gaining_point
  attr_accessor :my_deducting_point, :opponent_deducting_point
  attr_accessor :my_total_point,     :opponent_total_point
  attr_accessor :my_retry,           :opponent_retry
  attr_accessor :special_win, :time_minute, :time_second
  attr_accessor :hight
  attr_accessor :extra_time
  attr_accessor :jury_votes
  attr_accessor :my_jury_votes,      :opponent_jury_votes
  attr_accessor :memo

  validates :my_gaining_point,         format: { with: REX_GPT }
  validates :opponent_gaining_point,   format: { with: REX_GPT }
  validates :my_deducting_point,       format: { with: REX_DPT }
  validates :opponent_deducting_point, format: { with: REX_DPT }
  validates :my_total_point,           format: { with: REX_TPT }
  validates :opponent_total_point,     format: { with: REX_TPT }
  validates :my_retry,                 format: { with: REX_RT }
  validates :opponent_retry,           format: { with: REX_RT }
  with_options if: :special_win do
    validates :time_minute,            format: { with: REX_MS }
    validates :time_second,            format: { with: REX_MS }
  end
  validates :hight,       inclusion: { in: [ "true", "false", nil ] }
  validates :extra_time,  inclusion: { in: [ "true", "false", nil ] }
  with_options if: :jury_votes do
    validates :my_jury_votes,          format: { with: REX_VT }
    validates :opponent_jury_votes,    format: { with: REX_VT }
  end
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_gaining_point,   :opponent_gaining_point,
      :my_deducting_point, :opponent_deducting_point,
      :my_total_point,     :opponent_total_point,
      :my_retry,           :opponent_retry,
      :special_win, :time_minute, :time_second,
      :hight,
      :extra_time,
      :jury_votes,
      :my_jury_votes,      :opponent_jury_votes,
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
    if hash[:special_win].presence.to_bool
      h["special_win"] = "true"
      h.update(compose_time(hash: hash)) # h["time"]
    end
    h["hight"]      = "true"           if hash[:hight].present?
    h["extra_time"] = "true"           if hash[:extra_time].present?
    h.delete("jury_votes") unless hash["jury_votes"].presence.to_bool
    h["memo"]       = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["gaining_point"].present?
        self.my_gaining_point, self.opponent_gaining_point =
          h["gaining_point"].to_s.split(DELIMITER)
      end
      if h["deducting_point"].present?
        self.my_deducting_point, self.opponent_deducting_point =
          h["deducting_point"].to_s.split(DELIMITER)
      end
      if h["total_point"].present?
        self.my_total_point, self.opponent_total_point =
          h["total_point"].to_s.split(REX_SC)[1..-1]
      end
      self.my_retry, self.opponent_retry =
        h["retry"].to_s.split(DELIMITER) if h["retry"].present?
      if h["special_win"].present? and h["time"].present?
        self.special_win = true
        self.time_minute, self.time_second =
          h["time"].to_s.split(DELIMITER_TIME)
      end
      self.hight      = h["hight"].presence.to_bool
      self.extra_time = h["extra_time"].presence.to_bool
      if h["jury_votes"].present?
        self.jury_votes = true
        self.my_jury_votes, self.opponent_jury_votes =
          h["jury_votes"].to_s.split(DELIMITER)
      end
      self.memo       = h["memo"].presence || ''
    end
  end

end
