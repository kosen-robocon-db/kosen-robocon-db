class GameDetail12th < GameDetail
  # 最大15点？ 緑ゾーン1点、中央に運べば3点、得点後、Vスポットにおける権利を得る
  # 減点あり
  # Vゴールあり
  # 引き分けの場合、使用電力量が少ない方を勝ちとする

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code gaining_point deducting_point total_point )

  REX_GPT = /[0-9]|[1-3][0-9]|4[0-5]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_DPT = /[0-5]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_TPT =
    /-[1-5]|[0-9]|[1-3][0-9]|4[0-5]|#{GameDetail::Constant::UNKNOWN_VALUE}/

  # Vホールのように条件を満足すれば即勝利となったときの試合決着時間は
  # special_time_minute/secondとはせず、time_minute/secondとして
  # 他の試合決着時間を記録する大会の変数名と合わせている。
  attr_accessor :my_gaining_point, :opponent_gaining_point
  attr_accessor :my_deducting_point, :opponent_deducting_point
  attr_accessor :my_total_point, :opponent_total_point
  attr_accessor :special_win, :time_minute, :time_second
  attr_accessor :lower_power_quantity
  attr_accessor :memo

  validates :my_gaining_point,         format: { with: REX_GPT }
  validates :opponent_gaining_point,   format: { with: REX_GPT }
  validates :my_deducting_point,       format: { with: REX_DPT }
  validates :opponent_deducting_point, format: { with: REX_DPT }
  validates :my_total_point,           format: { with: REX_TPT }
  validates :opponent_total_point,     format: { with: REX_TPT }
  validates :special_win,          inclusion: { in: [ "true", "false", nil ] }
  with_options if: :special_win do
    validates :time_minute, format: { with: REX_MS }
    validates :time_second, format: { with: REX_MS }
  end
  validates :lower_power_quantity, inclusion: { in: [ "true", "false", nil ] }
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_gaining_point,   :opponent_gaining_point,
      :my_deducting_point, :opponent_deducting_point,
      :my_total_point,     :opponent_total_point,
      :special_win, :time_minute, :time_second,
      :lower_power_quantity,
      :memo
    ]
  end

  def stems
    STEMS
  end

  def self.compose_properties(hash:)
    h = super(hash: hash) || {}
    h.update(compose_pairs(hash: hash, stems: STEMS))
    if
      hash[:special_win].presence.to_bool and
      hash[:time_minute].present? and
      hash[:time_second].present?
    then
      h["special_win"] = "\
        #{hash[:time_minute]}\
        #{DELIMITER_TIME}\
        #{hash[:time_second]}\
      ".gsub(/(\s| )+/, '')
    end
    h["lower_power_quantity"] = "true" if hash[:lower_power_quantity].present?
    h["memo"]                 = "#{hash[:memo]}" if hash[:memo].present?
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
      if h["special_win"].present?
        self.special_win = true
        self.time_minute, self.time_second =
          h["special_win"].to_s.split(DELIMITER_TIME)
      end
      self.lower_power_quantity =
        h["lower_power_quantity"].presence.to_bool || false
      self.memo = h["memo"].presence || ''
    end
  end

end
