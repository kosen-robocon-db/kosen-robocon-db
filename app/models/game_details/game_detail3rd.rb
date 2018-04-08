class GameDetail3rd < GameDetail

  # 予選では勝敗に関わらず審査員推薦によって本戦出場が決まることがあった。
  # 本戦では引き分けの場合にジャンケンで勝敗を決めた。

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい値を持つ属性の語幹を書いておく
  STEMS = %w( robot_code gaining_point )

  REX_GPT = /\A([0-9]|1[0-6]|#{UNKNOWN})\z/

  enum criterium: {
    win:         0, # 勝利
    recommended: 1, # 審査員推薦
    janken:      2  # じゃんけん
  }

  attr_accessor :my_gaining_point, :opponent_gaining_point
  attr_accessor :extra_time
  attr_accessor :judgement # judgement by a criterium
  attr_accessor :memo

  validates :my_gaining_point,       format: { with: REX_GPT }
  validates :opponent_gaining_point, format: { with: REX_GPT }
  validates :extra_time, inclusion: { in: [ "true", "false", nil ] }
  validates :judgement,  inclusion: { in: criteria.each.map { |k,v| v.to_s } }
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_gaining_point, :opponent_gaining_point,
      :extra_time,
      :judgement,
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
    h["extra_time"] = "true"                if hash[:extra_time].present?
    h["judgement"]  = "#{hash[:judgement]}" if hash[:judgement].present?
    h["memo"]       = "#{hash[:memo]}"      if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["gaining_point"].present?
        self.my_gaining_point, self.opponent_gaining_point =
          h["gaining_point"].to_s.split(DELIMITER)
      end
      self.extra_time = h["extra_time"].presence.to_bool
      self.judgement  = h["judgement"].presence || criteria[:win]
      self.memo       = h["memo"].presence      || ''
    end
  end

end
