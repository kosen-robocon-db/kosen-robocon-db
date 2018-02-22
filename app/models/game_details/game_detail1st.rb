class GameDetail1st < GameDetail

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  ROOTS = %w( robot_code time_minute time_second )

  REX   = /#{DELIMITER}|#{DELIMITER_TIME}/

  attr_accessor :my_time_minute, :my_time_second
  attr_accessor :opponent_time_minute, :opponent_time_second
  attr_accessor :memo

  # 下記の*_time_minnute, *_time_second検証は現バージョンんでは必要ないかもしれない。
  with_options if: :my_time_minute do
    validates :my_time_minute, format: { with: REX_MS }
  end
  with_options if: :my_time_second do
    validates :my_time_second, format: { with: REX_MS }
  end
  with_options if: :opponent_time_minute do
    validates :opponent_time_minute, format: { with: REX_MS }
  end
  with_options if: :opponent_time_second do
    validates :opponent_time_second, format: { with: REX_MS }
  end
  validates :memo, length: { maximum: 255 }

  # DBにはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_time_minute, :my_time_second,
      :opponent_time_minute, :opponent_time_second,
      :memo
    ]
  end

  def roots
    ROOTS
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
            h["time"].to_s.split(REX) # この時点ではREにマッチしたとしている
      end
      self.memo = h["memo"].presence || ''
    end
  end

end
