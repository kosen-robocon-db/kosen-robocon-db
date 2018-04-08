class GameDetail1st < GameDetail

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい値を持つ属性の語幹を書いておく
  STEMS = %w( robot_code time_minute time_second )

  attr_accessor :my_time_minute, :my_time_second
  attr_accessor :opponent_time_minute, :opponent_time_second
  attr_accessor :memo

  # notice : propertiesを生成した後に次のvalidationが実行される
  validates :my_time_minute, format: { with: REX_MS }
  validates :my_time_second, format: { with: REX_MS }
  validates :opponent_time_minute, format: { with: REX_MS }
  validates :opponent_time_second, format: { with: REX_MS }
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_time_minute, :my_time_second,
      :opponent_time_minute, :opponent_time_second,
      :memo
    ]
  end

  # 親クラスから子クラスのSTEM定数を参照するためのメソッド
  def stems
    STEMS
  end

  def self.compose_properties(hash:)
    h = super(hash: hash) || {}
    h.update(compose_time(hash: hash))
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["time"].present? then
        self.my_time_minute, self.my_time_second,
          self.opponent_time_minute, self.opponent_time_second =
            h["time"].to_s.split(DELIMITER_TIME_PAIR)
      end
      self.memo = h["memo"].presence || ''
    end
  end

end
