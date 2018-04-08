class GameDetail16th < GameDetail
  # 同点の場合は円盤の傾き（角度）で勝敗を決める（減点されて0-0でも傾きで勝敗を決める）
  # 傾きでも決められないときは審査員判定（地区3名、全国？名）
  # 減点ありだが、得点しているときだけ減点されるのか？つまりマイナス点がない？
  # （現時点では負の合計点数がないとものとしている。）
  # リトライは1回のみ

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code gaining_point deducting_point total_point retry
    jury_votes )

  REX_GPT = /\A([0-3]|#{UNKNOWN})\z/
  REX_DPT = /\A([0-3]|#{UNKNOWN})\z/
  REX_TPT = /\A([0-3]|#{UNKNOWN})\z/
  REX_RT  = /\A([0-1]|#{UNKNOWN})\z/
  REX_VT  = /\A([0-5]|#{UNKNOWN})\z/

  attr_accessor :my_gaining_point,   :opponent_gaining_point
  attr_accessor :my_deducting_point, :opponent_deducting_point
  attr_accessor :my_total_point,     :opponent_total_point
  attr_accessor :my_retry,           :opponent_retry
  attr_accessor :inclination
  attr_accessor :jury_votes
  attr_accessor :my_jury_votes,      :opponent_jury_votes
  attr_accessor :memo

  validates :my_gaining_point,         format: { with: REX_GPT }
  validates :opponent_gaining_point,   format: { with: REX_GPT }
  validates :my_deducting_point,       format: { with: REX_DPT }
  validates :opponent_deducting_point, format: { with: REX_DPT }
  validates :my_total_point,           format: { with: REX_TPT }
  validates :opponent_total_point,     format: { with: REX_TPT }
  validates :my_retry,                 format: { with: REX_RT }
  validates :opponent_retry,           format: { with: REX_RT }
  validates :inclination, inclusion: { in: [ "true", "false", nil ] }
  with_options if: :jury_votes do
    validates :my_jury_votes,          format: { with: REX_VT }
    validates :opponent_jury_votes,    format: { with: REX_VT }
  end
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_gaining_point,   :opponent_gaining_point,
      :my_deducting_point, :opponent_deducting_point,
      :my_total_point,     :opponent_total_point,
      :my_retry,           :opponent_retry,
      :inclination,
      :jury_votes,
      :my_jury_votes,      :opponent_jury_votes,
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
    h["inclination"] = "true"           if hash[:inclination].present?
    h.delete("jury_votes") unless hash["jury_votes"].presence.to_bool
    h["memo"]        = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["gaining_point"].present?
        self.my_gaining_point, self.opponent_gaining_point =
          h["gaining_point"].to_s.split(DELIMITER)
      end
      if h["deducting_point"].present?
        self.my_deducting_point, self.opponent_deducting_point =
          h["deducting_point"].to_s.split(DELIMITER)
      end
      if h["total_point"].present?
        self.my_total_point, self.opponent_total_point =
          h["total_point"].to_s.split(DELIMITER)
      end
      self.my_retry, self.opponent_retry =
        h["retry"].to_s.split(DELIMITER) if h["retry"].present?
      self.inclination = h["inclination"].presence.to_bool
      if h["jury_votes"].present?
        self.jury_votes = true
        self.my_jury_votes, self.opponent_jury_votes =
          h["jury_votes"].to_s.split(DELIMITER)
      end
      self.memo = h["memo"].presence || ''
    end
  end

end
