class GameDetail1st < GameDetail

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい値を持つ属性の語幹を書いておく
  STEMS = %w( robot_code time_minute time_second )

  REX_T = /#{DELIMITER}|#{DELIMITER_TIME}/

  attr_accessor :my_time_minute, :my_time_second
  attr_accessor :opponent_time_minute, :opponent_time_second
  attr_accessor :memo

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

  def stems
    STEMS
  end

  def self.compose_properties(hash:)
    h = super(hash: hash) || {}
    if
      hash[:my_time_minute].present? and
      hash[:my_time_second].present? and
      hash[:opponent_time_minute].present? and
      hash[:opponent_time_second].present?
    then
      h["time"] = "\
        #{hash[:my_time_minute]}\
        #{DELIMITER_TIME}\
        #{hash[:my_time_second]}\
        #{DELIMITER}\
        #{hash[:opponent_time_minute]}\
        #{DELIMITER_TIME}\
        #{hash[:opponent_time_second]}\
      ".gsub(/(\s| )+/, '')
    end
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["time"].present? then
        self.my_time_minute, self.my_time_second,
          self.opponent_time_minute, self.opponent_time_second =
            h["time"].to_s.split(REX_T)
      end
      self.memo = h["memo"].presence || ''
    end
  end

end
