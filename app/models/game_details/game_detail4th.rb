class GameDetail4th < GameDetail

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい値を持つ属性の語幹を書いておく
  STEMS = %w( robot_code gaining_point )

  REX_GPT = /([0-9]|[1-3][0-9]|40|#{GameDetail::Constant::UNKNOWN_VALUE})/

  attr_accessor :my_gaining_point, :opponent_gaining_point
  attr_accessor :extra_time
  attr_accessor :hight, :distance, :janken
  attr_accessor :memo

  validates :my_gaining_point,       format: { with: REX_GPT }
  validates :opponent_gaining_point, format: { with: REX_GPT }
  validates :extra_time, inclusion: { in: [ "true", "false", nil ] }
  validates :hight,      inclusion: { in: [ "true", "false", nil ] }
  validates :distance,   inclusion: { in: [ "true", "false", nil ] }
  validates :janken,     inclusion: { in: [ "true", "false", nil ] }
  validates :extra_time, inclusion: { in: [ "true", "false", nil ] }
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_gaining_point, :opponent_gaining_point,
      :extra_time,
      :hight, :distance, :janken,
      :memo
    ]
  end

  def stems
    STEMS
  end

  def self.compose_properties(hash:)
    h = compose_pairs(hash: hash, stems: STEMS)
    h["extra_time"] = "true"           if hash[:extra_time].present?
    h["hight"]      = "true"           if hash[:hight].present?
    h["distance"]   = "true"           if hash[:distance].present?
    h["janken"]     = "true"           if hash[:janken].present?
    h["memo"]       = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["gaining_point"].present?
        self.my_gaining_point, self.opponent_gaining_point =
          h["gaining_point"].to_s.split(REX_SC)[1..-1]
      end
      self.extra_time = h["extra_time"].presence.to_bool || false
      self.hight      = h["hight"].presence.to_bool      || false
      self.distance   = h["distance"].presence.to_bool   || false
      self.janken     = h["janken"].presence.to_bool     || false
      self.memo       = h["memo"].presence               || ''
    end
  end

end
