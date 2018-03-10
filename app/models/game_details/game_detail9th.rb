class GameDetail9th < GameDetail

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  ROOTS = %w( robot_code point )

  REX_PT = /[0-9]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_HT = /#{DELIMITER_TIME}/

  attr_accessor :my_point, :opponent_point
  attr_accessor :hat_trick, :hat_trick_time_minute, :hat_trick_time_second
  attr_accessor :extra_time # 再々延長ルールはあったが適用される試合はなかったはず
  attr_accessor :memo

  # validates に numericality: {} を指定したいところだが(分かり易いが)、
  # format: {} のほうが手間がかからないようなので、採用した。
  # 減点があったかどうか不明だが、得点だけを実装しておいた。
  validates :my_point, format: { with: REX_PT }
  validates :opponent_point, format: { with: REX_PT }
  # 下記の*_time_minnute, *_time_second検証は現バージョンんでは必要ないかもしれない。
  with_options if: :hat_trick_time_minute do
    validates :hat_trick_time_minute, format: { with: REX_MS }
  end
  with_options if: :hat_trick_time_second do
    validates :hat_trick_time_second, format: { with: REX_MS }
  end
  validates :memo, length: { maximum: 255 }

  # DBにはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_point, :opponent_point,
      :hat_trick, :hat_trick_time_minute, :hat_trick_time_second,
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
    if
      hash[:hat_trick].present? and
      hash[:hat_trick_time_minute].present? and
      hash[:hat_trick_time_second].present?
    then
      h["hat_trick"] = "\
        #{hash[:hat_trick_time_minute]}\
        #{DELIMITER_TIME}\
        #{hash[:hat_trick_time_second]}\
      ".gsub(/(\s| )+/, '')
    end
    h["extra_time"] = "true" if hash[:extra_time].present?
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["point"].present?
        self.my_point, self.opponent_point = h["point"].to_s.split(DELIMITER)
      end
      if h["hat_trick"].present? then
        self.hat_trick = true
        self.hat_trick_time_minute, self.hat_trick_time_second =
            h["hat_trick"].to_s.split(REX_HT)
      end
      self.extra_time = h["extra_time"].present? ? true : false
      self.memo = h["memo"].presence || ''
    end
  end

end
