class GameDetail8th < GameDetail

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code gaining_point deducting_point total_point
    basket_drible )

  REX_GPT = /[0-9]|[1-5][0-9]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_DPT = /[0-5]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_TPT = /-[1-5]|[0-9]|[1-5][0-9]|#{GameDetail::Constant::UNKNOWN_VALUE}/

  # Vホールのように条件を満足すれば即勝利となったときの試合決着時間は
  # special_time_minute/secondとはせず、time_minute/secondとして
  # 他の試合決着時間を記録する大会の変数名と合わせている。
  attr_accessor :my_gaining_point,   :opponent_gaining_point
  attr_accessor :my_deducting_point, :opponent_deducting_point
  attr_accessor :my_total_point,     :opponent_total_point
  attr_accessor :my_basket_drible,   :opponent_basket_drible
  attr_accessor :special_win, :time_minute, :time_second
  attr_accessor :extra_time
  attr_accessor :memo

  validates :my_gaining_point,         format: { with: REX_GPT }
  validates :opponent_gaining_point,   format: { with: REX_GPT }
  validates :my_deducting_point,       format: { with: REX_DPT }
  validates :opponent_deducting_point, format: { with: REX_DPT }
  validates :my_total_point,           format: { with: REX_TPT }
  validates :opponent_total_point,     format: { with: REX_TPT }
  validates :my_basket_drible,       inclusion: { in: [ "true", "false", nil ] }
  validates :opponent_basket_drible, inclusion: { in: [ "true", "false", nil ] }
  with_options if: :special_win do
    validates :time_minute,            format: { with: REX_MS }
    validates :time_second,            format: { with: REX_MS }
  end
  validates :extra_time,             inclusion: { in: [ "true", "false", nil ] }
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_gaining_point,   :opponent_gaining_point,
      :my_deducting_point, :opponent_deducting_point,
      :my_total_point,     :opponent_total_point,
      :my_basket_drible,   :opponent_basket_drible,
      :special_win, :time_minute, :time_second,
      :extra_time,
      :memo
    ]
  end

  def stems
    STEMS
  end

  def self.compose_properties(hash:)
    if # compose_pairsで拾えないbasket_dribleのケースに対応
      hash[:my_basket_drible].present? and
      hash[:opponent_basket_drible].blank?
    then
      hash[:opponent_basket_drible] = "false"
    end
    if # compose_pairsで拾えないbasket_dribleのケースに対応
      hash[:my_basket_drible].blank? and
      hash[:opponent_basket_drible].present?
    then
      hash[:my_basket_drible] = "false"
    end
    h = compose_pairs(hash: hash, stems: STEMS)
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
    h["extra_time"] = "true"           if hash[:extra_time].present?
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
      if h["basket_drible"].present?
        self.my_basket_drible, self.opponent_basket_drible =
          h["basket_drible"].to_s.split(DELIMITER).map{ |x| x.to_bool }
      end
      if h["special_win"].present?
        self.special_win = true
        self.time_minute, self.time_second =
          h["special_win"].to_s.split(DELIMITER_TIME)
      end
      self.extra_time = h["extra_time"].presence.to_bool || false
      self.memo       = h["memo"].presence               || ''
    end
  end

end
