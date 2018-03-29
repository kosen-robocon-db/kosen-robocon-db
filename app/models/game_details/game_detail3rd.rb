class GameDetail3rd < GameDetail

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい値を持つ属性の語幹を書いておく
  STEMS = %w( robot_code gaining_point )

  REX_GPT = /([0-9]|1[0-6]|#{GameDetail::Constant::UNKNOWN_VALUE})/

  attr_accessor :my_gaining_point, :opponent_gaining_point
  attr_accessor :extra_time
  attr_accessor :recommended, :janken
  attr_accessor :memo

  validates :my_gaining_point,       format: { with: REX_GPT }
  validates :opponent_gaining_point, format: { with: REX_GPT }
  validates :extra_time,  inclusion: { in: [ "true", "false", nil ] }
  validates :recommended, inclusion: { in: [ "true", "false", nil ] }
  validates :janken,      inclusion: { in: [ "true", "false", nil ] }
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_gaining_point, :opponent_gaining_point,
      :extra_time,
      :recommended, :janken,
      :memo
    ]
  end

  def stems
    STEMS
  end

  # extra_timeなどのbooleanとnilの三種の値の入力を想定しているフォーム属性変数について
  # trueかfalseかnilかをここで吟味すべきであるが、このproperties生成の後に実行される
  # save/update直前のvalidationによって吟味されるので、有るか無しか(nil)かを吟味する
  # だけにしている。
  def self.compose_properties(hash:)
    h = super(hash: hash) || {}
    h.update(compose_pairs(hash: hash, stems: STEMS))
    h["extra_time"]  = "true"           if hash[:extra_time].present?
    h["recommended"] = "true"           if hash[:recommended].present?
    h["janken"]      = "true"           if hash[:janken].present?
    h["memo"]        = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["gaining_point"].present?
        self.my_gaining_point, self.opponent_gaining_point =
          h["gaining_point"].to_s.split(REX_SC)[1..-1]
      end
      self.extra_time  = h["extra_time"].presence.to_bool  || false
      self.recommended = h["recommended"].presence.to_bool || false
      self.janken      = h["janken"].presence.to_bool      || false
      self.memo        = h["memo"].presence                || ''
    end
  end

end
