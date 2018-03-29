class GameDetail25th < GameDetail
  # 勝敗
  # 　赤い穴に赤のボールを入れて1点、虹色の穴に虹色のボールを入れると4点、
  #   点数の多い方が勝ち。
  #   9つ全ての穴に入れるとパーフェクトで、先にパーフェクトを達成した方が勝ち
  # リトライ
  #   何回まで？
  # 審査員判定
  #   地区3名、全国？名
  # 反則
  #   反則があれば・・・どうなるの？反則で後ろに下がったチームがあったが
  # 準決勝からレインボーゴールが増えて配置が変る
  # 1回戦は3分間またはパーフェクトするまで試合を続ける。

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code gaining_point time_minute time_second special_win
    penalty retry jury_votes )

  REX_GPT = /[0-9]|1[0-8]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_PN  = /[0-9]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_RT  = /[0-9]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_VT  = /[0-5]|#{GameDetail::Constant::UNKNOWN_VALUE}/

  attr_accessor :my_gaining_point, :opponent_gaining_point
  attr_accessor :my_special_win,   :opponent_special_win
  attr_accessor :my_time_minute,       :my_time_second
  attr_accessor :opponent_time_minute, :opponent_time_second
  attr_accessor :my_penalty,       :opponent_penalty
  attr_accessor :my_retry,         :opponent_retry
  attr_accessor :jury_votes, :my_jury_votes, :opponent_jury_votes
  attr_accessor :memo

  validates :my_gaining_point,       format: { with: REX_GPT }
  validates :opponent_gaining_point, format: { with: REX_GPT }
  validates :my_time_minute,         format: { with: REX_MS }
  validates :my_time_second,         format: { with: REX_MS }
  validates :opponent_time_minute,   format: { with: REX_MS }
  validates :opponent_time_second,   format: { with: REX_MS }
  validates :my_special_win,       inclusion: { in: [ "true", "false", nil ] }
  validates :opponent_special_win, inclusion: { in: [ "true", "false", nil ] }
  validates :my_penalty,             format: { with: REX_PN }
  validates :opponent_penalty,       format: { with: REX_PN }
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
      :my_gaining_point,   :opponent_gaining_point,
      :my_time_minute,       :my_time_second,
      :opponent_time_minute, :opponent_time_second,
      :my_special_win,     :opponent_special_win,
      :my_penalty,         :opponent_penalty,
      :my_retry,           :opponent_retry,
      :jury_votes, :my_jury_votes, :opponent_jury_votes,
      :memo
    ]
  end

  def stems
    STEMS
  end

  def self.compose_properties(hash:)
    h = super(hash: hash) || {} # 必要なのか？
    if # compose_pairsで拾えないspecial_winのケースに対応。どちらも無ければ必要なし。
      hash[:my_special_win].present? and
      hash[:opponent_special_win].blank?
    then
      hash[:opponent_special_win] = "false"
      hash[:opponent_time_minute] = "#{GameDetail::Constant::UNKNOWN_VALUE}"
      hash[:opponent_time_second] = "#{GameDetail::Constant::UNKNOWN_VALUE}"
    end
    if # compose_pairsで拾えないspecial_winのケースに対応。どちらも無ければ必要なし。
      hash[:my_special_win].blank? and
      hash[:opponent_special_win].present?
    then
      hash[:my_special_win] = "false"
      hash[:my_time_minute] = "#{GameDetail::Constant::UNKNOWN_VALUE}"
      hash[:my_time_second] = "#{GameDetail::Constant::UNKNOWN_VALUE}"
    end
    if
      hash[:my_time_minute].present? and
      hash[:my_time_second].present? and
      hash[:opponent_time_minute].present? and
      hash[:opponent_time_second].present?
    then
      h["time"] = "\
        #{hash[:my_time_minute]}\
        #{DELIMITER_TIME}\
        #{hash[:my_time_second]}\
        #{DELIMITER}\
        #{hash[:opponent_time_minute]}\
        #{DELIMITER_TIME}\
        #{hash[:opponent_time_second]}\
      ".gsub(/(\s| )+/, '')
    end
    h.update(compose_pairs(hash: hash, stems: %w(gaining_point special_win
      penalty retry jury_votes)))
    h.delete("jury_votes") unless hash["jury_votes"].presence.to_bool
    h["memo"]       = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["gaining_point"].present?
        self.my_gaining_point, self.opponent_gaining_point =
          h["gaining_point"].to_s.split(REX_SC)[1..-1]
      end
      if h["time"].present? then
        self.my_time_minute, self.my_time_second,
          self.opponent_time_minute, self.opponent_time_second =
            h["time"].to_s.split(REX_T)
      end
      if h["special_win"].present?
        self.my_special_win, self.opponent_special_win =
          h["special_win"].to_s.split(DELIMITER).map{ |x| x.to_bool }
      end
      if h["penalty"].present?
        self.my_penalty, self.opponent_penalty =
          h["penalty"].to_s.split(DELIMITER)
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
