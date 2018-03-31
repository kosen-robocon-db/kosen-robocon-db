class GameDetail29th < GameDetail
  # 完了（すべき）課題／課題進捗(progress)
  #   東北地区大会番組では次の分類になっていた
  #     灯台、出港、とりで
  #   参考にして次の区分にした。いずれも完了した状態を表している。
  #     0: スタートゾーン
  #     1: 灯台建築
  #     2: 出港
  #     3: 砦建築
  #   しかし一つを選ぶだけでは、出港のみであることがわからない。
  #   スタートゾーンを無くし、もう少し状況を加え、
  #   マルチ・チェック・ボックスで記録することにすべき。
  #     1: 灯台建築
  #     2: 出港
  #     3: 島上陸
  #     4: 新大陸上陸
  #     5: 砦建築（ブロック積まで）
  #     6: 砦建築（シンボル乗せて完成）
  #   なお、砦作りは灯台完成後に行える。
  # 反則
  #   反則5回で失格
  # リトライ
  #   何回でも可能
  # 勝敗
  #   両チームとも砦が完成してないときは、丘に積み上げたブロックが高い方を勝ちとする。
  #   丘に積み上げてない場合は審査員判定。
  # 審査員判定
  #   同点（同じ高さ）の場合は審査員判定（地区3名、全国？名）

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code gaining_point retry penalty progress jury_votes )

  UNKNOWN = GameDetail::Constant::UNKNOWN_VALUE

  REX_RT = /\A[0-9]\z|\A#{UNKNOWN}\z/
  REX_PN = /\A[0-5]\z|\A#{UNKNOWN}\z/
  REX_VT = /\A[0-5]\z|\A#{UNKNOWN}\z/

  # hight -> gaining_point に変更
  attr_accessor :my_gaining_point, :opponent_gaining_point
  attr_accessor :my_retry,         :opponent_retry
  attr_accessor :my_penalty,       :opponent_penalty
  attr_accessor :progress
  attr_accessor :my_progress,      :opponent_progress
  attr_accessor :jury_votes
  attr_accessor :my_jury_votes,    :opponent_jury_votes
  attr_accessor :memo

  validates :my_gaining_point,       numericality: {
    only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 1000
  }
  validates :opponent_gaining_point, numericality: {
    only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 1000
  }
  validates :my_retry,              format: { with: REX_RT }
  validates :opponent_retry,        format: { with: REX_RT }
  validates :my_penalty,            format: { with: REX_PN }
  validates :opponent_penalty,      format: { with: REX_PN }
  validates :progress,   inclusion: { in: [ "true", "false", nil ] }
  validates :jury_votes, inclusion: { in: [ "true", "false", nil ] }
  with_options if: :jury_votes do
    validates :my_jury_votes,       format: { with: REX_VT }
    validates :opponent_jury_votes, format: { with: REX_VT }
  end
  validates :memo, length: { maximum: MEMO_LEN }

  enum progresses: {
    lighthouse_building: 1, # 灯台建築
    departure:           2, # 出港
    island_landing:      3, # 島上陸
    continent_landing:   4, # 新大陸上陸
    fort_block_building: 5, # 砦建築（ブロック積まで）
    fort_symbol_setting: 6  # 砦建築（シンボル乗せて完成）
  }

  # DBにはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_gaining_point,        :opponent_gaining_point,
      :my_retry,                :opponent_retry,
      :my_penalty,              :opponent_penalty,
      :progress,
      { :my_progress => [] }, { :opponent_progress => [] },
      :jury_votes,
      :my_jury_votes,           :opponent_jury_votes,
      :memo
    ]
  end

  def stems
    STEMS
  end

  def self.compose_properties(hash:)
    h = compose_pairs(hash: hash, stems: %w(robot_code gaining_point retry
      penalty jury_votes))
    if hash["progress"].present? # エンコードしなければならないため
      h["progress"] = "\
        #{self.encode(hash[:my_progress])}\
        #{DELIMITER}\
        #{self.encode(hash[:opponent_progress])}\
      ".gsub(/(\s| )+/, '')
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
      end
      if h["retry"].present?
        self.my_retry, self.opponent_retry =
          h["retry"].to_s.split(DELIMITER)
      end
      if h["penalty"].present?
        self.my_penalty, self.opponent_penalty =
          h["penalty"].to_s.split(DELIMITER)
      end
      if h["progress"].present?
        self.progress = true
        self.my_progress, self.opponent_progress =
          h["progress"].to_s.split(DELIMITER).map{ |x| decode(x) }
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
