class GameDetail5th < GameDetail

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい値を持つ属性の語幹を書いておく
  STEMS = %w( robot_code gaining_point )

  attr_accessor :my_gaining_point, :opponent_gaining_point
  attr_accessor :extra_time
  attr_accessor :memo

  # 160点以上があるかもしれない・・・
  validates :my_point, numericality: {
    only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 160
  }
  validates :opponent_point, numericality: {
    only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 160
  }
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

  # SRP(Single Responsibility Principle, 単一責任原則)に従っていないが
  # このクラス内で実装する。
  def self.compose_properties(hash:)
    h = super(hash: hash) || {}
    STEMS.each do |stm|
      my_sym, opponent_sym = "my_#{stm}".to_sym, "opponent_#{stm}".to_sym
      if hash[my_sym].present? and hash[opponent_sym].present?
        h["#{stm}"] = "#{hash[my_sym]}#{DELIMITER}#{hash[opponent_sym]}"
      end
    end
    h["extra_time"] = hash[:extra_time].presence || "false"
    h["memo"]       = hash[:memo].presence       || nil
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
