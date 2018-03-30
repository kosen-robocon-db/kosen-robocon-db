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

  def stems
    STEMS
  end

  # extra_timeなどのbooleanとnilの三種の値の入力を想定しているフォーム属性変数について
  # trueかfalseかnilかをここで吟味すべきであるが、このproperties生成の後に実行される
  # save/update直前のvalidationによって吟味されるので、有るか無しか(nil)かを吟味する
  # だけにしている。他の数字や文字列が入力される属性も同様である。
  def self.compose_properties(hash:)
    h = super(hash: hash) || {} # ロボットコードが無い時点で例外を出すべきだが・・・
    h.update(compose_time(hash: hash))
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
