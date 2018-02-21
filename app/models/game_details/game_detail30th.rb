class GameDetail30th < GameDetail
  module Constant
    UNKNOWN_VALUE = "__"
    BALOON_MIN = 0
    BALOON_MAX = 10
  end

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  ROOTS  = %w( base_baloon robot_baloon jury_votes )

  REX_BL  = /([0-9]|10|#{Constant::UNKNOWN_VALUE})/
  REX_MS  = /([0-5][0-9]|#{Constant::UNKNOWN_VALUE})/
  REX_VT  = /([0-5]|#{Constant::UNKNOWN_VALUE})/

  attr_accessor :my_robot_baloon, :opponent_robot_baloon
  attr_accessor :my_base_baloon, :opponent_base_baloon
  attr_accessor :jury_votes, :my_jury_votes, :opponent_jury_votes
  attr_accessor :time_minute, :time_second

  with_options if: :my_robot_baloon do
    validates :my_robot_baloon, format: { with: REX_BL }
  end
  with_options if: :opponent_robot_baloon do
    validates :opponent_robot_baloon, format: { with: REX_BL }
  end
  with_options if: :my_base_baloon do
    validates :my_base_baloon, format: { with: REX_BL }
  end
  with_options if: :opponent_base_baloon do
    validates :opponent_base_baloon, format: { with: REX_BL }
  end
  with_options if: :time_minute do
    validates :time_minute, format: { with: REX_MS }
  end
  with_options if: :time_second do
    validates :time_second, format: { with: REX_MS }
  end
  with_options if: :jury_votes do
    validates :my_jury_votes, format: { with: REX_VT }
    validates :opponent_jury_votes, format: { with: REX_VT }
  end

  # DBにはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_robot_baloon, :opponent_robot_baloon,
      :my_base_baloon, :opponent_base_baloon,
      :jury_votes, :my_jury_votes, :opponent_jury_votes,
      :time_minute, :time_second
    ]
  end

  def roots
    ROOTS
  end

  def self.compose_properties(hash:)
    h = super(hash: hash) || {}
    ROOTS.each do |pr|
      my_sym, opponent_sym = "my_#{pr}".to_sym, "opponent_#{pr}".to_sym
      if hash[my_sym].present? and hash[opponent_sym].present?
        h["#{pr}"] = "#{hash[my_sym]}#{DELIMITER}#{hash[opponent_sym]}"
      end
    end
    if hash[:time_minute].present? and hash[:time_second].present? then
      h["time"] = "\
        #{hash[:time_minute]}\
        #{DELIMITER_TIME}\
        #{hash[:time_second]}\
      ".gsub(/(\s| )+/, '')
    end
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      self.my_base_baloon, self.opponent_base_baloon =
        h["base_baloon"].to_s.split(DELIMITER) if h["base_baloon"].present?
      self.my_robot_baloon, self.opponent_robot_baloon =
        h["robot_baloon"].to_s.split(DELIMITER) if h["robot_baloon"].present?
      self.jury_votes = h["jury_votes"].present? ? true : false
      self.my_jury_votes, self.opponent_jury_votes =
        h["jury_votes"].to_s.split(DELIMITER) if h["jury_votes"].present?
      if h["time"].present? then
        self.time_minute, self.time_second =
          h["time"].to_s.split(DELIMITER_TIME)
      end
    end
  end

end
