class GameDetail4th < GameDetail

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  ROOTS = %w( robot_code point )

  REX_PT = /([0-9]|1[0-9]|20|#{GameDetail::Constant::UNKNOWN_VALUE})/

  attr_accessor :my_point, :opponent_point
  attr_accessor :extra_time
  attr_accessor :hight, :distance, :janken
  attr_accessor :memo

  validates :my_point, format: { with: REX_PT }
  validates :opponent_point, format: { with: REX_PT }
  validates :memo, length: { maximum: 255 }

  # DBにはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_point, :opponent_point,
      :extra_time,
      :hight, :distance, :janken,
      :memo
    ]
  end

  def roots
    ROOTS
  end

  # SRP(Single Responsibility Principle, 単一責任原則)に従っていないが
  # このクラス内で実装する。
  def self.compose_properties(hash:)
    h = super(hash: hash) || {}
    ROOTS.each do |pr|
      my_sym, opponent_sym = "my_#{pr}".to_sym, "opponent_#{pr}".to_sym
      if hash[my_sym].present? and hash[opponent_sym].present?
        h["#{pr}"] = "#{hash[my_sym]}#{DELIMITER}#{hash[opponent_sym]}"
      end
    end
    h["extra_time"] = "true" if hash[:extra_time].present?
    h["hight"] = "true" if hash[:hight].present?
    h["distance"] = "true" if hash[:distance].present?
    h["janken"]     = "true" if hash[:janken].present?
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      self.my_point, self.opponent_point =
        h["point"].to_s.split(REX_SC)[1..-1] if h["point"].present?
      self.extra_time = h["extra_time"].present? ? true : false
      self.hight = h["hight"].present? ? true : false
      self.distance = h["distance"].present? ? true : false
      self.janken = h["janken"].present? ? true : false
        # 上四つは h[].presence || false のようにしたらよいのではないだろうか？
      self.memo = h["memo"].presence || ''
    end
  end

end
