class GameDetail10th < GameDetail

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code gaining_point art_point total_point )

  REX_GPT = /[0-9]|1[0-8]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_APT = /[0-9]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_TPT = /[0-9]|1[0-9]|2[0-7]|#{GameDetail::Constant::UNKNOWN_VALUE}/

  attr_accessor :my_gaining_point, :opponent_gaining_point
  attr_accessor :my_art_point,     :opponent_art_point
  attr_accessor :my_total_point,   :opponent_total_point
  attr_accessor :extra_time
  attr_accessor :memo

  validates :my_gaining_point,       format: { with: REX_GPT }
  validates :opponent_gaining_point, format: { with: REX_GPT }
  validates :my_art_point,           format: { with: REX_APT }
  validates :opponent_art_point,     format: { with: REX_APT }
  validates :my_total_point,         format: { with: REX_TPT }
  validates :opponent_total_point,   format: { with: REX_TPT }
  validates :extra_time, inclusion: { in: [ "true", "false", nil ] }
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_gaining_point, :opponent_gaining_point,
      :my_art_point,     :opponent_art_point,
      :my_total_point,   :opponent_total_point,
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
      if h["art_point"].present?
        self.my_art_point, self.opponent_art_point =
          h["art_point"].to_s.split(REX_SC)[1..-1]
      end
      if h["total_point"].present?
        self.my_total_point, self.opponent_total_point =
          h["total_point"].to_s.split(REX_SC)[1..-1]
      end
      self.extra_time = h["extra_time"].presence.to_bool || false
      self.memo       = h["memo"].presence               || ''
    end
  end

end
