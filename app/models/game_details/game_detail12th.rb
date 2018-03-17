class GameDetail12th < GameDetail
  # 最大15点？ 緑ゾーン1点、中央に運べば3点、得点後、Vスポットにおける権利を得る
  # 減点あり
  # Vゴールあり
  # 引き分けの場合、使用電力量が少ない方を勝ちとする

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code gaining_point deducting_point total_point )

  REX_GPT = /[0-9]|[1-3][0-9]|4[0-5]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_DGT = /[0-5]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_TPT =
    /-[1-5]|[0-9]|[1-3][0-9]|4[0-5]|#{GameDetail::Constant::UNKNOWN_VALUE}/

  attr_accessor :my_gaining_point, :opponent_gaining_point
  attr_accessor :my_deducting_point, :opponent_deducting_point
  attr_accessor :my_total_point, :opponent_total_point
  attr_accessor :special_win, :special_win_time_minute, :special_win_time_second
  attr_accessor :lower_power_quantity
  attr_accessor :memo

  validates :my_gaining_point,         format: { with: REX_GPT }
  validates :opponent_gaining_point,   format: { with: REX_GPT }
  validates :my_deducting_point,       format: { with: REX_DPT }
  validates :opponent_deducting_point, format: { with: REX_DPT }
  validates :my_total_point,           format: { with: REX_TPT }
  validates :opponent_total_point,     format: { with: REX_TPT }
  validates :special_win,          inclusion: { in: [ "true", "false" ] }
  with_options if: :special_win do
    validates :special_win_time_minute, format: { with: REX_MS }
    validates :special_win_time_second, format: { with: REX_MS }
  end
  validates :lower_power_quantity, inclusion: { in: [ "true", "false" ] }
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_gaining_point,   :opponent_gaining_point,
      :my_deducting_point, :opponent_deducting_point,
      :my_total_point,     :opponent_total_point,
      :special_win, :special_win_time_minute, :special_win_time_second,
      :lower_power_quantity,
      :memo
    ]
  end

  def stems
    STEMS
  end

  def self.compose_properties(hash:)
    h = super(hash: hash) || {}
    STEMS.each do |stm|
      my_sym, opponent_sym = "my_#{stm}".to_sym, "opponent_#{stm}".to_sym
      if hash[my_sym].present? and hash[opponent_sym].present?
        h["#{stm}"] = "#{hash[my_sym]}#{DELIMITER}#{hash[opponent_sym]}"
      end
    end
    h["special_win"] = hash[:special_win].presence || "false"
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
    h["lower_power_quantity"] = hash[:lower_power_quantity].presence || "false"
    h["memo"]                 = hash[:memo].presence                 || nil
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
      self.special_win = h["special_win"].presence.to_bool || false
      self.special_win_time_minute, self.special_win_time_second =
          h["special_win"].to_s.split(DELIMITER_TIME) if self.special_win
      self.lower_power_quantity =
        h["lower_power_quantity"].presence.to_bool || false
      self.memo = h["memo"].presence || ''
    end
  end

end
