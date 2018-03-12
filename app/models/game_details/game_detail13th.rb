class GameDetail13th < GameDetail

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  ROOTS = %w( robot_code point jury_votes )

  REX_PT = /[0-9]|10|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_VT = /([0-5]|#{GameDetail::Constant::UNKNOWN_VALUE})/
    # 地区、全国ともに5人で判定。主審も加わる。

  attr_accessor :my_point, :opponent_point
  attr_accessor :perfect_performance
  attr_accessor :perfect_performance_time_minute
  attr_accessor :perfect_performance_time_second
  attr_accessor :jury_votes, :my_jury_votes, :opponent_jury_votes
  attr_accessor :memo

  # validates に numericality: {} を指定したいところだが(分かり易いが)、
  # format: {} のほうが手間がかからないようなので、採用した。
  # 減点があったかどうか不明だが、得点だけを実装しておいた。
  validates :my_point, format: { with: REX_PT }
  validates :opponent_point, format: { with: REX_PT }
  # 下記の*_time_minnute, *_time_second検証は現バージョンんでは必要ないかもしれない。
  with_options if: :perfect_performance do
    validates :perfect_performance_time_minute, format: { with: REX_MS }
  end
  with_options if: :perfect_performance do
    validates :perfect_performance_time_second, format: { with: REX_MS }
  end
  with_options if: :jury_votes do
    validates :my_jury_votes, format: { with: REX_VT }
    validates :opponent_jury_votes, format: { with: REX_VT }
  end
  validates :memo, length: { maximum: 255 }

  # DBにはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_point, :opponent_point,
      :perfect_performance,
      :perfect_performance_time_minute,
      :perfect_performance_time_second,
      :jury_votes, :my_jury_votes, :opponent_jury_votes,
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
    if
      hash[:perfect_performance].present? and
      hash[:perfect_performance_time_minute].present? and
      hash[:perfect_performance_time_second].present?
    then
      h["perfect_performance"] = "\
        #{hash[:perfect_performance_time_minute]}\
        #{DELIMITER_TIME}\
        #{hash[:perfect_performance_time_second]}\
      ".gsub(/(\s| )+/, '')
    end
    h.delete("jury_votes") unless hash["jury_votes"].present?
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["point"].present?
        self.my_point, self.opponent_point =
          h["point"].to_s.split(REX_SC)[1..-1]
      end
      if h["perfect_performance"].present? then
        self.perfect_performance = true
        self.perfect_performance_time_minute,
          self.perfect_performance_time_second =
            h["perfect_performance"].to_s.split(DELIMITER_TIME)
      end
      self.jury_votes = h["jury_votes"].present? ? true : false
      self.my_jury_votes, self.opponent_jury_votes =
        h["jury_votes"].to_s.split(DELIMITER) if h["jury_votes"].present?
      self.memo = h["memo"].presence || ''
    end
  end

end
