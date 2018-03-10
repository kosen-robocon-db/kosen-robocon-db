class GameDetail7th < GameDetail

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  ROOTS = %w( robot_code point )

  REX_PT  = /[0-9]|[1-3][0-9]|40|#{GameDetail::Constant::UNKNOWN_VALUE}/

  attr_accessor :my_point, :opponent_point
  attr_accessor :v_goal
  attr_accessor :extra_time # 再々延長ルールはあったが適用される試合はなかったはず
  attr_accessor :memo

  # validates に numericality: {} を指定したいところだが(分かり易いが)、
  # format: {} のほうが手間がかからないようなので、採用した。
  # 減点があったかどうか不明だが、得点だけを実装しておいた。
  validates :my_point, format: { with: REX_PT }
  validates :opponent_point, format: { with: REX_PT }
  validates :memo, length: { maximum: 255 }

  # DBにはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_point, :opponent_point,
      :v_goal,
      :extra_time,
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
    h["v_goal"] = "true" if hash[:v_goal].present?
    h["extra_time"] = "true" if hash[:extra_time].present?
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["point"].present?
        self.my_point, self.opponent_point = h["point"].to_s.split(DELIMITER)
      end
      self.v_goal = h["v_goal"].present? ? true : false
      self.extra_time = h["extra_time"].present? ? true : false
      self.memo = h["memo"].presence || ''
    end
  end

end
