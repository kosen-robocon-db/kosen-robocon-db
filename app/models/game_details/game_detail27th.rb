class GameDetail27th < GameDetail
  # 完了課題(progress)
  #   0: スタートゾーン
  #   1: スラロームゾーン
  #   2: 角材ゾーン
  #   3: 傾斜ゾーン
  #   4: 蒸籠受け取り
  #   5: 傾斜ゾーン（戻り）
  #   6: ・・・
  #   実装しようと思ったが、相手の蒸籠を奪えるルールから察するに
  #   ロボットが何往復も可能であると想定されていたと推測する。
  #   仮にそうであれば途中の障害の進捗度を克服できることは当たり前なので
  #   態々入力する必要はないと判断する。
  #   ただ、地区大会によっては両チームとも得点できず進んだ位置で審査員判断されたと
  #   目される試合がある。それはメモに記すべき。
  # 勝敗
  #   蒸籠を運んだ枚数が多い方が勝ち
  #   蒸籠の枚数が同数の場合は審査員判定（地区3名、全国5名）
  # リトライ
  #   何回でも可能？蒸籠を落したらゾーンの初めからやり直し？そして20秒間待つ？
  # 注文
  #   蒸籠を運ぶ前に運ぶ枚数を宣言する
  # 相手から蒸籠を奪い取るルール
  #   60枚以上の蒸籠を運び終えれば相手の机から蒸籠を奪って自分の机に置くことが
  #   可能だったが、そんなチームは無かったのでこれは入力フォームに用意しない。
  # 運ばれた蒸籠の最大枚数
  #   地区36枚（四国地区大会高松A牛車）
  #   全国48枚（八代本気の宅配便）

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code delivered gaining_point retry steamer_fall jury_votes )

  REX_DLV = /\A([0-3]|#{UNKNOWN})\z/
  REX_GPT = /\A([1-4]{,1}[0-9]|#{UNKNOWN})\z/
  REX_RT  = /\A([0-9]|#{UNKNOWN})\z/
  REX_SF  = /\A([0-9]|#{UNKNOWN})\z/
  REX_VT  = /\A([0-5]|#{UNKNOWN})\z/

  attr_accessor :my_delivered, :opponent_delivered
  attr_accessor :my_gaining_point,   :opponent_gaining_point
  attr_accessor :my_retry,           :opponent_retry
  attr_accessor :my_steamer_fall,    :opponent_steamer_fall
  attr_accessor :jury_votes
  attr_accessor :my_jury_votes,      :opponent_jury_votes
  attr_accessor :memo

  validates :my_delivered,       format: { with: REX_DLV }
  validates :opponent_delivered, format: { with: REX_DLV }
  validates :my_gaining_point,         format: { with: REX_GPT }
  validates :opponent_gaining_point,   format: { with: REX_GPT }
  validates :my_retry,                 format: { with: REX_RT }
  validates :opponent_retry,           format: { with: REX_RT }
  validates :my_steamer_fall,          format: { with: REX_SF }
  validates :opponent_steamer_fall,    format: { with: REX_SF }
  with_options if: :jury_votes do
    validates :my_jury_votes,          format: { with: REX_VT }
    validates :opponent_jury_votes,    format: { with: REX_VT }
  end
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_delivered,     :opponent_delivered,
      :my_gaining_point, :opponent_gaining_point,
      :my_retry,         :opponent_retry,
      :my_steamer_fall,  :opponent_steamer_fall,
      :jury_votes,
      :my_jury_votes,    :opponent_jury_votes,
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
    h.delete("jury_votes") unless hash["jury_votes"].presence.to_bool
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["delivered"].present?
        self.my_delivered, self.opponent_delivered =
          h["delivered"].to_s.split(DELIMITER)
      end
      if h["gaining_point"].present?
        self.my_gaining_point, self.opponent_gaining_point =
          h["gaining_point"].to_s.split(DELIMITER)
      end
      if h["retry"].present?
        self.my_retry, self.opponent_retry =
          h["retry"].to_s.split(DELIMITER)
      end
      if h["steamer_fall"].present?
        self.my_steamer_fall, self.opponent_steamer_fall =
          h["steamer_fall"].to_s.split(DELIMITER)
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
