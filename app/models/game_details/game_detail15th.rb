class GameDetail15th < GameDetail

  # リトライ１回のみ
  # 減点あり（箱を落す・壊すなど）
  # 　減点3回で失格
  # 獲得スポット数が同数の場合、高く積んでる方が勝ち
  # 引き分け時は審査員判定。地区3人、全国？人。または1分間の延長？
  #   地区によって異なる？
  # トルネード（15段積み）ができたら即勝ち

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  ROOTS = %w( robot_code gaining_point deducting_point total_point retry
    jury_votes )

  REX_PT = /[0-3]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_TPT = /-[1-3]|[0-3]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_VT = /([0-5]|#{GameDetail::Constant::UNKNOWN_VALUE})/
    # 地区、全国ともに5人？（要確認）

  attr_accessor :my_gaining_point, :opponent_gaining_point
  attr_accessor :my_deducting_point, :opponent_deducting_point
  attr_accessor :my_total_point, :opponent_total_point
  attr_accessor :my_retry, :opponent_retry
  attr_accessor :hight
  attr_accessor :extra_time
  attr_accessor :jury_votes, :my_jury_votes, :opponent_jury_votes
  attr_accessor :memo # これは game_details に持たせたほうがよいのでは？

  # validates に numericality: {} を指定したいところだが(分かり易いが)、
  # format: {} のほうが手間がかからないようなので、採用した。
  validates :my_gaining_point, format: { with: REX_PT }
  validates :opponent_gaining_point, format: { with: REX_PT }
  validates :my_deducting_point, format: { with: REX_PT }
  validates :opponent_deducting_point, format: { with: REX_PT }
  validates :my_total_point, format: { with: REX_TPT }
  validates :opponent_total_point, format: { with: REX_TPT }
  with_options if: :jury_votes do
    validates :my_jury_votes, format: { with: REX_VT }
    validates :opponent_jury_votes, format: { with: REX_VT }
  end
  validates :memo, length: { maximum: 255 }

  # DBにはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_gaining_point, :opponent_gaining_point,
      :my_deducting_point, :opponent_deducting_point,
      :my_total_point, :opponent_total_point,
      :my_retry, :opponent_retry,
      :hight,
      :extra_time,
      :jury_votes, :my_jury_votes, :opponent_jury_votes,
      :memo
    ]
  end

  def roots # stems に変更すべき
    ROOTS # STEMS に変更すべき
  end

  # SRP(Single Responsibility Principle, 単一責任原則)に従っていないが
  # このクラス内で実装する。
  def self.compose_properties(hash:)
    h = super(hash: hash) || {}
    ROOTS.each do |pr|
      my_sym, opponent_sym = "my_#{pr}".to_sym, "opponent_#{pr}".to_sym
      if hash[my_sym].present? and hash[opponent_sym].present?
        h["#{pr}"] = "#{hash[my_sym]}#{DELIMITER}#{hash[opponent_sym]}"
      end
    end
    h["hight"] = "true" if hash[:hight].present?
    h["extra_time"] = "true" if hash[:extra_time].present?
    h.delete("jury_votes") unless hash["jury_votes"].present?
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      # *_pointの類はもっと簡潔にまとめられないか？
      if h["gaining_point"].present?
        self.my_gaining_point, self.opponent_gaining_point =
          h["gaining_point"].to_s.split(REX_SC)[1..-1]
      end
      if h["deducting_point"].present?
        self.my_deducting_point, self.opponent_deducting_point =
          h["deducting_point"].to_s.split(REX_SC)[1..-1]
      end
      if h["total_point"].present?
        self.my_total_point, self.opponent_total_point =
          h["total_point"].to_s.split(REX_SC)[1..-1]
      end
      if h["retry"].present?
        self.my_retry, self.opponent_retry =
          h["retry"].to_s.split(DELIMITER).map{ |x| x.to_bool }
      end
      self.hight = h["hight"].present? ? true : false      
      self.extra_time = h["extra_time"].present? ? true : false
      self.jury_votes = h["jury_votes"].present? ? true : false
      self.my_jury_votes, self.opponent_jury_votes =
        h["jury_votes"].to_s.split(DELIMITER) if h["jury_votes"].present?
      self.memo = h["memo"].presence || ''
    end
  end

end
