class GameDetail11th < GameDetail

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  ROOTS = %w( robot_code gaining_point deducting_point total_point )

  REX_PT  = /[0-9]|[1-3][0-9]|40|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_TPT = /-[1-5]|[0-9]|[1-3][0-9]|40|#{GameDetail::Constant::UNKNOWN_VALUE}/

  attr_accessor :my_gaining_point, :opponent_gaining_point
  attr_accessor :my_deducting_point, :opponent_deducting_point
  attr_accessor :my_total_point, :opponent_total_point
  attr_accessor :recommended
  attr_accessor :memo

  # validates に numericality: {} を指定したいところだが(分かり易いが)、
  # format: {} のほうが手間がかからないようなので、採用した。
  validates :my_gaining_point, format: { with: REX_PT }
  validates :opponent_gaining_point, format: { with: REX_PT }
  validates :my_deducting_point, format: { with: REX_PT }
  validates :opponent_deducting_point, format: { with: REX_PT }
  validates :my_total_point, format: { with: REX_TPT }
  validates :opponent_total_point, format: { with: REX_TPT }
  validates :memo, length: { maximum: 255 }

  # DBにはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_gaining_point, :opponent_gaining_point,
      :my_deducting_point, :opponent_deducting_point,
      :my_total_point, :opponent_total_point,
      :recommended,
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
    h["recommended"] = "true" if hash[:recommended].present?
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
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
      self.recommended = h["recommended"].present? ? true : false
      self.memo = h["memo"].presence || ''
    end
  end

end
