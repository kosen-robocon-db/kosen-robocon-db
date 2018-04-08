class GameDetail10th < GameDetail

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code gaining_point art_point total_point )

  REX_GPT = /\A([0-9]|1[0-8]|#{UNKNOWN})\z/
  REX_APT = /\A([0-9]|#{UNKNOWN})\z/
  REX_TPT = /\A([0-9]|1[0-9]|2[0-7]|#{UNKNOWN})\z/

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

  # 親クラスから子クラスのSTEM定数を参照するためのメソッド
  def stems
    STEMS
  end

  # extra_timeなどのbooleanとnilの三種の値の入力を想定しているフォーム属性変数について
  # trueかfalseかnilかをここで吟味すべきであるが、このproperties生成の後に実行される
  # save/update直前のvalidationによって吟味されるので、有るか無しか(nil)かを吟味する
  # だけにしている。他の数字や文字列が入力される属性も同様である。
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
          h["gaining_point"].to_s.split(DELIMITER)
      end
      if h["art_point"].present?
        self.my_art_point, self.opponent_art_point =
          h["art_point"].to_s.split(DELIMITER)
      end
      if h["total_point"].present?
        self.my_total_point, self.opponent_total_point =
          h["total_point"].to_s.split(DELIMITER)
      end
      self.extra_time = h["extra_time"].presence.to_bool
      self.memo       = h["memo"].presence || ''
    end
  end

end
