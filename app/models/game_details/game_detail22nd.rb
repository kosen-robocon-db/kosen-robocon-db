class GameDetail22nd < GameDetail
  # 同点の場合審査員判定（地区3名、全国5名）
  #   因みに審査員は
  #   森正弘（東京工業大学　名誉教授）、清水優史（前橋工科大学　特任教授）
  #   森理世（モデル／プロダンサー）、冷水佐壽（高等専門学校連合会会長）
  #   新山賢治（NHK制作局長）
  # 課題(challenges)の種類
  #    1:プレゼントをとる　　　（ 5点）
  #    2:プレゼントを渡す　　　（ 5点）
  #    3:ペアダンス　　　　　　（10点）ここまでのシーケンスは必須
  #    4:ポールターン　　　　　（10点）以下は選択が自由
  #    5:シンクロスピン　　　　（10点）
  #    6:リフト　　　　　　　　（10点）
  #    7:ローリングジャンプ回転（20点）
  #    8:ローリングジャンプ着地（10点）
  #    9:スターステージ　　　　（10点）
  #   10:スターカップル　　　　（10点）

  # my_robot_code側から見ているので、
  # ロボットコードが異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code challenges gaining_point retry jury_votes )

  REX_GPT = /\A(\d{,1}(0|5))\z|\A100\z|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_RT  = /[0-9]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_VT  = /[0-5]|#{GameDetail::Constant::UNKNOWN_VALUE}/

  attr_accessor :my_challenges,    :opponent_challenges
  attr_accessor :my_gaining_point, :opponent_gaining_point
  attr_accessor :my_retry,         :opponent_retry
  attr_accessor :jury_votes,
  attr_accessor :my_jury_votes,    :opponent_jury_votes
  attr_accessor :memo

  validates :my_gaining_point,       format: { with: REX_GPT }
  validates :opponent_gaining_point, format: { with: REX_GPT }
  validates :my_retry,               format: { with: REX_RT }
  validates :opponent_retry,         format: { with: REX_RT }
  with_options if: :jury_votes do
    validates :my_jury_votes,        format: { with: REX_VT }
    validates :opponent_jury_votes,  format: { with: REX_VT }
  end
  validates :memo, length: { maximum: MEMO_LEN }

  enum challenges: {
    present_taking:         1, # プレゼントをとる　　　（ 5点）
    present_giving:         2, # プレゼントを渡す　　　（ 5点）
    pair_dancing:           3, # ペアダンス　　　　　　（10点）
    pole_turning:           4, # ポールターン　　　　　（10点）
    synchronous_spining:    5, # シンクロスピン　　　　（10点）
    lifting:                6, # リフト　　　　　　　　（10点）
    jumping_while_rolling:  7, # ローリングジャンプ回転（20点）
    landing_after_jumping:  8, # ローリングジャンプ着地（10点）
    star_staging:           9, # スターステージ　　　　（10点）
    star_coupling:         10  # スターカップル　　　　（10点）
  }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      { :my_challenges => [] }, { :opponent_challenges => [] },
      :my_gaining_point,          :opponent_gaining_point,
      :my_retry,                  :opponent_retry,
      :jury_votes,
      :my_jury_votes,             :opponent_jury_votes,
      :memo
    ]
  end

  def stems
    STEMS
  end

  def self.compose_properties(hash:)
    hash[:my_challenges]       = self.encode(hash[:my_challenges])
    hash[:opponent_challenges] = self.encode(hash[:opponent_challenges])
    h = compose_pairs(hash: hash, stems: STEMS)
    h.delete("jury_votes") unless hash["jury_votes"].presence.to_bool
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["challenges"].present?
        self.my_challenges, self.opponent_challenges =
          h["challenges"].to_s.split(DELIMITER).map{ |x| decode(x) }
      end
      if h["gaining_point"].present?
        self.my_gaining_point, self.opponent_gaining_point =
          h["gaining_point"].to_s.split(REX_SC)[1..-1]
      end
      self.my_retry, self.opponent_retry =
        h["retry"].to_s.split(DELIMITER) if h["retry"].present?
      if h["jury_votes"].present?
        self.jury_votes = true
        self.my_jury_votes, self.opponent_jury_votes =
          h["jury_votes"].to_s.split(DELIMITER)
      end
      self.memo = h["memo"].presence || ''
    end
  end

end
