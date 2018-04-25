class GameDetail22nd < GameDetail
  # 同点の場合審査員判定（地区3名、全国5名）
  #   因みに審査員は
  #   森正弘（東京工業大学　名誉教授）、清水優史（前橋工科大学　特任教授）
  #   森理世（モデル／プロダンサー）、冷水佐壽（高等専門学校連合会会長）
  #   新山賢治（NHK制作局長）
  # 完了課題(challenges)の種類
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
  STEMS = %w( robot_code challenge gaining_point retry jury_votes )

  REX_GPT = /\A([1-9]{,1}(0|5)|100|#{UNKNOWN})\z/
  REX_RT  = /\A([0-9]|#{UNKNOWN})\z/
  REX_VT  = /\A([0-5]|#{UNKNOWN})\z/

  enum challenge: {
    # 何もチェックせず、得点が記載されていれば不明かどうかは判別できる。
    # unknown(0)は何も選択されなかったときとしているので設定しない。
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

  attr_accessor :my_challenge,     :opponent_challenge
  attr_accessor :my_gaining_point, :opponent_gaining_point
  attr_accessor :my_retry,         :opponent_retry
  attr_accessor :jury_votes
  attr_accessor :my_jury_votes,    :opponent_jury_votes
  attr_accessor :memo

  # *_challengeのバリデーションは省略している。
  validates :my_gaining_point,       format: { with: REX_GPT }
  validates :opponent_gaining_point, format: { with: REX_GPT }
  validates :my_retry,               format: { with: REX_RT }
  validates :opponent_retry,         format: { with: REX_RT }
  with_options if: :jury_votes do
    validates :my_jury_votes,        format: { with: REX_VT }
    validates :opponent_jury_votes,  format: { with: REX_VT }
  end
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      { :my_challenge => [] }, { :opponent_challenge => [] },
      :my_gaining_point,         :opponent_gaining_point,
      :my_retry,                 :opponent_retry,
      :jury_votes,
      :my_jury_votes,            :opponent_jury_votes,
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
    h = super(hash: hash) || {}
    h["challenge"] = "\
      #{self.encode(hash[:my_challenge])}\
      #{DELIMITER}\
      #{self.encode(hash[:opponent_challenge])}\
    ".gsub(/(\s| )+/, '')
    h.update(compose_pairs(hash: hash,
      stems: %w( gaining_point retry jury_votes )))
    h.delete("jury_votes") unless hash["jury_votes"].presence.to_bool
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["challenge"].present?
        self.my_challenge, self.opponent_challenge =
          h["challenge"].to_s.split(DELIMITER).map{ |x| decode(x) }
      end
      if h["gaining_point"].present?
        self.my_gaining_point, self.opponent_gaining_point =
          h["gaining_point"].to_s.split(DELIMITER)
      end
      if h["retry"].present?
        self.my_retry, self.opponent_retry = h["retry"].to_s.split(DELIMITER)
      end
      if h["jury_votes"].present?
        self.jury_votes = true
        self.my_jury_votes, self.opponent_jury_votes =
          h["jury_votes"].to_s.split(DELIMITER)
      end
      self.memo = h["memo"].presence || ''
    end
  end

end
