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

  REX_GPT = /[0-3]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_DPT = /[0-3]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_TPT = /-[1-3]|[0-3]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_RT  = /[0-1]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_VT  = /[0-5]|#{GameDetail::Constant::UNKNOWN_VALUE}/

  attr_accessor :my_gaining_point, :opponent_gaining_point
  attr_accessor :my_deducting_point, :opponent_deducting_point
  attr_accessor :my_total_point, :opponent_total_point
  attr_accessor :my_retry, :opponent_retry
  attr_accessor :special_win, :special_win_time_minute, :special_win_time_second
  attr_accessor :hight
  attr_accessor :extra_time
  attr_accessor :jury_votes, :my_jury_votes, :opponent_jury_votes
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
    validates :special_win_time_minute, format: { with: REX_MS }
    validates :special_win_time_second, format: { with: REX_MS }
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
      :special_win, :special_win_time_minute, :special_win_time_second,
      :hight,
      :extra_time,
      :jury_votes, :my_jury_votes, :opponent_jury_votes,
      :memo
    ]
  end

  def stems
    STEMS
  end

  def self.compose_properties(hash:)
    h = super(hash: hash) || {} # robot_code
    h.update(compose_pairs(hash: hash, stems: STEMS))
    if
      hash[:special_win].presence.to_bool and
      hash[:special_win_time_minute].present? and
      hash[:special_win_time_second].present?
    then
      h["special_win"] = "\
        #{hash[:special_win_time_minute]}\
        #{DELIMITER_TIME}\
        #{hash[:special_win_time_second]}\
      ".gsub(/(\s| )+/, '')
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
          h["gaining_point"].to_s.split(REX_SC)[1..-1]
      end
      if h["deducting_point"].present?
        self.my_deducting_point, self.opponent_deducting_point =
          h["deducting_point"].to_s.split(REX_SC)[1..-1]
      end
      if h["total_point"].present?
        self.my_total_point, self.opponent_total_point =
          h["total_point"].to_s.split(REX_SC)[1..-1]
      end
      self.my_retry, self.opponent_retry =
        h["retry"].to_s.split(DELIMITER) if h["retry"].present?
      if h["special_win"].present?
        self.special_win = true
        self.special_win_time_minute, self.special_win_time_second =
          h["special_win"].to_s.split(DELIMITER_TIME)
      end
      self.hight       = h["hight"].presence.to_bool      || false
      self.extra_time  = h["extra_time"].presence.to_bool || false
      if h["jury_votes"].present?
        self.jury_votes = true
        self.my_jury_votes, self.opponent_jury_votes =
          h["jury_votes"].to_s.split(DELIMITER)
      end
      self.memo        = h["memo"].presence               || ''
    end
  end

end
