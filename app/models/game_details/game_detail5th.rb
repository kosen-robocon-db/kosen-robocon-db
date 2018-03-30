class GameDetail5th < GameDetail

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい値を持つ属性の語幹を書いておく
  STEMS = %w( robot_code gaining_point )

  attr_accessor :my_gaining_point, :opponent_gaining_point
  attr_accessor :extra_time
  attr_accessor :memo

  # 160点以上があるかもしれない・・・
  # 不明を入力可能にしたい
  validates :my_gaining_point, numericality: {
    only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 160
  }
  validates :opponent_gaining_point, numericality: {
    only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 160
  }
  validates :extra_time, inclusion: { in: [ "true", "false", nil ] }
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_gaining_point, :opponent_gaining_point,
      :extra_time,
      :memo
    ]
  end

  def stems
    STEMS
  end

  def self.compose_properties(hash:)
    h = compose_pairs(hash: hash, stems: STEMS)
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
      self.extra_time = h["extra_time"].presence.to_bool || false
      self.memo       = h["memo"].presence               || ''
    end
  end

end
