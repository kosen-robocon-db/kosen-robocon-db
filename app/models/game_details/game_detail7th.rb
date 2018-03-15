class GameDetail7th < GameDetail

  # 再々延長ルールはあったが適用される試合はなかったはず

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code gaining_point )

  REX_GPT = /[0-9]|[1-3][0-9]|40|#{GameDetail::Constant::UNKNOWN_VALUE}/

  attr_accessor :my_gaining_point, :opponent_gaining_point
  attr_accessor :special_win, :special_win_time_minute, :special_win_time_second
  attr_accessor :extra_time
  attr_accessor :memo

  validates :my_gaining_point,        format: { with: REX_GPT }
  validates :opponent_gaining_point,  format: { with: REX_GPT }
  validates :special_win, inclusion: { in: [ "true", "false" ] }
  validates :special_win_time_minute, format: { with: REX_MS }
  validates :special_win_time_second, format: { with: REX_MS }
  validates :extra_time,  inclusion: { in: [ "true", "false" ] }
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_gaining_point, :opponent_gaining_point,
      :special_win, :special_win_time_minute, :special_win_time_second,
      :extra_time,
      :memo
    ]
  end

  def stems
    STEMS
  end

  def self.compose_properties(hash:)
    h = super(hash: hash) || {}
    STEMS.each do |stm|
      my_sym, opponent_sym = "my_#{stm}".to_sym, "opponent_#{stm}".to_sym
      if hash[my_sym].present? and hash[opponent_sym].present?
        h["#{stm}"] = "#{hash[my_sym]}#{DELIMITER}#{hash[opponent_sym]}"
      end
    end
    h["special_win"] = hash[:special_win].presence || "false"
    if
      hash[:special_win].presence.to_bool and
      hash[:special_win_time_minute].present? and
      hash[:special_win_time_second].present?
    then
      h["special_win"] = "\
        #{hash[:special_win_time_minute]}\
        #{DELIMITER_TIME}\
        #{hash[:special_win_time_second]}\
      ".gsub(/(\s| )+/, '')
    end
    h["extra_time"] = hash[:extra_time].presence || "false"
    h["memo"]       = hash[:memo].presence       || nil
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["gaining_point"].present?
        self.my_gaining_point, self.opponent_gaining_point =
          h["gaining_point"].to_s.split(REX_SC)[1..-1]
      end
      self.special_win = h["special_win"].presence.to_bool || false
      self.special_win_time_minute, self.special_win_time_second =
          h["special_win"].to_s.split(DELIMITER_TIME) if self.special_win
      self.extra_time  = h["extra_time"].presence.to_bool  || false
      self.memo        = h["memo"].presence                || ''
    end
  end

end
