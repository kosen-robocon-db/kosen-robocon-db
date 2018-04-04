class GameDetail17th < GameDetail
  # 反則
  #   反則1回につき50cm距離追加
  # 勝敗
  #   距離が短い方が勝ち
  #   計測は0.5cm刻み
  #   同じ距離の場合は審査員判定
  # 審査員判定
  # 　メッセンジャーボールの距離が同じであれば審査員判定（地区3名、全国？名）

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code gaining_point deducting_point total_point retry
    jury_votes )

  REX_GPT = /\A(([1-9]\d{,2}|0)(\.5+)?|)\z/ # 何も入力しないを許す。
  REX_DPT = /\A([0-9]|#{UNKNOWN})\z/
  REX_TPT = /\A(([1-9]\d{,2}|0)(\.5+)?|)\z/ # 何も入力しないを許す。負なしと仮定。
  REX_RT  = /\A([0-1]|#{UNKNOWN})\z/
  REX_VT  = /\A([0-5]|#{UNKNOWN})\z/

  attr_accessor :my_gaining_point,   :opponent_gaining_point   # 距離の代わり
  attr_accessor :my_deducting_point, :opponent_deducting_point # 反則数の代わり
  attr_accessor :my_total_point,     :opponent_total_point     # 距離の代わり
  attr_accessor :my_retry,           :opponent_retry
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
      :jury_votes,
      :my_jury_votes,      :opponent_jury_votes,
      :memo
    ]
  end

  # 親クラスから子クラスのSTEM定数を参照するためのメソッド
  def stems
    STEMS
  end

  def self.compose_properties(hash:)
    h = super(hash: hash) || {}
    # compose_pairsで拾えないgaining_point(入力なし)に対応
    if
      hash[:my_gaining_point].present? and
      hash[:opponent_gaining_point].present?
    then
      h["gaining_point"] = "\
        #{hash[:my_gaining_point]}\
        #{DELIMITER}\
        #{hash[:opponent_gaining_point]}\
      ".gsub(/(\s| )+/, '')
    end
    if
      hash[:my_gaining_point].present? and
      hash[:opponent_gaining_point].blank?
    then
      h["gaining_point"] = "\
        #{hash[:my_gaining_point]}\
        #{DELIMITER}\
        #{UNKNOWN}\
      ".gsub(/(\s| )+/, '')
    end
    if
      hash[:my_gaining_point].blank? and
      hash[:opponent_gaining_point].present?
    then
      h["gaining_point"] = "\
        #{UNKNOWN}\
        #{DELIMITER}\
        #{hash[:opponent_gaining_point]}\
      ".gsub(/(\s| )+/, '')
    end
    h.update(compose_pairs(hash: hash, stems: %w( deducting_point )))
    # compose_pairsで拾えないtotal_point(入力なし)に対応
    if
      hash[:my_total_point].present? and
      hash[:opponent_total_point].present?
    then
      h["total_point"] = "\
        #{hash[:my_total_point]}\
        #{DELIMITER}\
        #{hash[:opponent_total_point]}\
      ".gsub(/(\s| )+/, '')
    end
    if
      hash[:my_total_point].present? and
      hash[:opponent_total_point].blank?
    then
      h["total_point"] = "\
        #{hash[:my_total_point]}\
        #{DELIMITER}\
        #{UNKNOWN}\
      ".gsub(/(\s| )+/, '')
    end
    if
      hash[:my_total_point].blank? and
      hash[:opponent_total_point].present?
    then
      h["total_point"] = "\
        #{UNKNOWN}\
        #{DELIMITER}\
        #{hash[:opponent_total_point]}\
      ".gsub(/(\s| )+/, '')
    end
    h.update(compose_pairs(hash: hash, stems: %w( retry jury_votes )))
    if hash[:special_win].presence.to_bool
      h["special_win"] = "true"
      h.update(compose_time(hash: hash)) # h["time"]
    end
    h.delete("jury_votes") unless hash["jury_votes"].presence.to_bool
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["gaining_point"].present?
        self.my_gaining_point, self.opponent_gaining_point =
          h["gaining_point"].to_s.split(DELIMITER)
        self.my_gaining_point =
          "" if self.my_gaining_point == "#{UNKNOWN}"
        self.opponent_gaining_point =
          "" if self.opponent_gaining_point == "#{UNKNOWN}"
      end
      if h["deducting_point"].present?
        self.my_deducting_point, self.opponent_deducting_point =
          h["deducting_point"].to_s.split(DELIMITER)
      end
      if h["total_point"].present?
        self.my_total_point, self.opponent_total_point =
          h["total_point"].to_s.split(DELIMITER)
        self.my_total_point =
          "" if self.my_total_point == "#{UNKNOWN}"
        self.opponent_total_point =
          "" if self.opponent_total_point == "#{UNKNOWN}"
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
