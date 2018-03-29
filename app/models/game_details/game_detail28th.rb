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
  STEMS = %w( robot_code gaining_point number_of_two_pole number_of_three_pole
    special_win special_win_time_minute special_win_time_second
    number_of_loading retry penalty jury_votes )

  UNKNOWN = GameDetail::Constant::UNKNOWN_VALUE

  REX_GPT = /\A[1-2]{,1}[0-9]\z|\A#{UNKNOWN}\z/
  REX_2P  = /\A[0-3]\z|\A#{UNKNOWN}\z/
  REX_3P  = /\A[0-3]\z|\A#{UNKNOWN}\z/
  REX_LD  = /\A[0-9]\z|\A#{UNKNOWN}\z/
  REX_RT  = /\A[0-9]\z|\A#{UNKNOWN}\z/
  REX_PN  = /\A[0-9]\z|\A#{UNKNOWN}\z/
  REX_VT  = /\A[0-5]\z|\A#{UNKNOWN}\z/

  attr_accessor :my_gaining_point,           :opponent_gaining_point
  attr_accessor :my_number_of_two_pole,      :opponent_number_of_two_pole
  attr_accessor :my_number_of_three_pole,    :opponent_number_of_three_pole
  attr_accessor :my_special_win,             :opponent_special_win
  attr_accessor :my_special_win_time_minute, :opponent_special_win_time_minute
  attr_accessor :my_special_win_time_second, :opponent_special_win_time_second
  attr_accessor :my_number_of_loading,       :opponent_number_of_loading
  attr_accessor :my_retry,                   :opponent_retry
  attr_accessor :my_penalty,                 :opponent_penalty
  attr_accessor :jury_votes, :my_jury_votes, :opponent_jury_votes
  attr_accessor :memo

  validates :my_gaining_point,                 format: { with: REX_GPT }
  validates :opponent_gaining_point,           format: { with: REX_GPT }
  validates :my_number_of_two_pole,            format: { with: REX_2P }
  validates :opponent_number_of_two_pole,      format: { with: REX_2P }
  validates :my_number_of_three_pole,          format: { with: REX_3P }
  validates :opponent_number_of_three_pole,    format: { with: REX_3P }
  validates :my_special_win,       inclusion: { in: [ "true", "false", nil ] }
  validates :opponent_special_win, inclusion: { in: [ "true", "false", nil ] }
  validates :my_special_win_time_minute,       format: { with: REX_MS }
  validates :my_special_win_time_second,       format: { with: REX_MS }
  validates :opponent_special_win_time_minute, format: { with: REX_MS }
  validates :opponent_special_win_time_second, format: { with: REX_MS }
  validates :my_number_of_loading,             format: { with: REX_LD }
  validates :opponent_number_of_loading,       format: { with: REX_LD }
  validates :my_retry,                         format: { with: REX_RT }
  validates :opponent_retry,                   format: { with: REX_RT }
  validates :my_penalty,                       format: { with: REX_PN }
  validates :opponent_penalty,                 format: { with: REX_PN }
  with_options if: :jury_votes do
    validates :my_jury_votes,                  format: { with: REX_VT }
    validates :opponent_jury_votes,            format: { with: REX_VT }
  end
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_gaining_point,           :opponent_gaining_point,
      :my_number_of_two_pole,      :opponent_number_of_two_pole,
      :my_number_of_three_pole,    :opponent_number_of_three_pole,
      :my_special_win,             :opponent_special_win,
      :my_special_win_time_minute, :opponent_special_win_time_minute,
      :my_special_win_time_second, :opponent_special_win_time_second,
      :my_number_of_loading,       :opponent_number_of_loading,
      :my_retry,                   :opponent_retry,
      :my_penalty,                 :opponent_penalty,
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
      hash[:opponent_special_win_time_minute] =
        "#{GameDetail::Constant::UNKNOWN_VALUE}"
      hash[:opponent_special_win_time_second] =
        "#{GameDetail::Constant::UNKNOWN_VALUE}"
    end
    if # compose_pairsで拾えないspecial_winのケースに対応。どちらも無ければ必要なし。
      hash[:my_special_win].blank? and
      hash[:opponent_special_win].present?
    then
      hash[:my_special_win] = "false"
      hash[:my_special_win_time_minute] =
        "#{GameDetail::Constant::UNKNOWN_VALUE}"
      hash[:my_special_win_time_second] =
        "#{GameDetail::Constant::UNKNOWN_VALUE}"
    end
    if
      hash[:my_special_win_time_minute].present? and
      hash[:my_special_win_time_second].present? and
      hash[:opponent_special_win_time_minute].present? and
      hash[:opponent_special_win_time_second].present?
    then
      h["special_win_time"] = "\
        #{hash[:my_special_win_time_minute]}\
        #{DELIMITER_TIME}\
        #{hash[:my_special_win_time_second]}\
        #{DELIMITER}\
        #{hash[:opponent_special_win_time_minute]}\
        #{DELIMITER_TIME}\
        #{hash[:opponent_special_win_time_second]}\
      ".gsub(/(\s| )+/, '')
      logger.debug(">>>> special_win_time:#{h["special_win_time"].to_yaml}")
    end
    h.update(compose_pairs(hash: hash, stems: %w(
      gaining_point number_of_two_pole number_of_three_pole special_win
      number_of_loading retry penalty jury_votes
    )))
    h.delete("jury_votes") unless hash["jury_votes"].presence.to_bool
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["gaining_point"].present?
        self.my_gaining_point, self.opponent_gaining_point =
          h["gaining_point"].to_s.split(REX_SC)[1..-1]
      end
      if h["number_of_two_pole"].present?
        self.my_number_of_two_pole, self.opponent_number_of_two_pole =
          h["number_of_two_pole"].to_s.split(DELIMITER)
      end
      if h["number_of_three_pole"].present?
        self.my_number_of_three_pole, self.opponent_number_of_three_pole =
          h["number_of_three_pole"].to_s.split(DELIMITER)
      end
      if h["special_win"].present?
        self.my_special_win, self.opponent_special_win =
          h["special_win"].to_s.split(DELIMITER).map{ |x| x.to_bool }
      end
      if h["special_win_time"].present? then
        self.my_special_win_time_minute,
          self.my_special_win_time_second,
            self.opponent_special_win_time_minute,
              self.opponent_special_win_time_second =
                h["special_win_time"].to_s.split(REX_T)
      end
      if h["number_of_loading"].present? then
        self.my_number_of_loading, self.opponent_number_of_loading =
          h["number_of_loading"].to_s.split(DELIMITER)
      end
      if h["retry"].present?
        self.my_retry, self.opponent_retry =
          h["retry"].to_s.split(DELIMITER)
      end
      if h["penalty"].present?
        self.my_penalty, self.opponent_penalty =
          h["penalty"].to_s.split(DELIMITER)
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
