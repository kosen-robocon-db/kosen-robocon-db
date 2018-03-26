class GameDetail24th < GameDetail

  # 勝敗
  #   ボールをノーバウンドキャッチするタッチダウンパス成功までの時間が短い方が勝ち。
  #   タッチダウンパスが無ければ、ノーバウンドでボールにタッチした回数が多い方が勝ち。
  # 審査員判定
  #   タッチダウンパスの時間が同じ場合、またはボールタッチ回数が同じ場合は審査員判定。
  #   地区全国ともに審査員は3名。


  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code time_minute time_second ball_touch intercept retry
     jury_votes )

  REX_T  = /#{DELIMITER}|#{DELIMITER_TIME}/
  REX_BT = /[0-9]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_IN = /[0-3]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_RT = /[0-9]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_VT = /[0-3]|#{GameDetail::Constant::UNKNOWN_VALUE}/

  attr_accessor :my_time_minute,       :my_time_second
  attr_accessor :opponent_time_minute, :opponent_time_second
  attr_accessor :my_ball_touch,        :opponent_ball_touch
  attr_accessor :my_intercept,         :opponent_intercept
  attr_accessor :my_retry,             :opponent_retry
  attr_accessor :jury_votes, :my_jury_votes, :opponent_jury_votes
  attr_accessor :memo

  validates :my_time_minute,        format: { with: REX_MS }
  validates :my_time_second,        format: { with: REX_MS }
  validates :opponent_time_minute,  format: { with: REX_MS }
  validates :opponent_time_second,  format: { with: REX_MS }
  validates :my_ball_touch,         format: { with: REX_BT }
  validates :opponent_ball_touch,   format: { with: REX_BT }
  validates :my_intercept,          format: { with: REX_IN }
  validates :opponent_intercept,    format: { with: REX_IN }
  validates :my_retry,              format: { with: REX_RT }
  validates :opponent_retry,        format: { with: REX_RT }
  with_options if: :jury_votes do
    validates :my_jury_votes,       format: { with: REX_VT }
    validates :opponent_jury_votes, format: { with: REX_VT }
  end
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_time_minute,       :my_time_second,
      :opponent_time_minute, :opponent_time_second,
      :my_ball_touch,        :opponent_ball_touch,
      :my_intercept,         :opponent_intercept,
      :my_retry,             :opponent_retry,
      :jury_votes, :my_jury_votes, :opponent_jury_votes,
      :memo
    ]
  end

  def stems
    STEMS
  end

  def self.compose_properties(hash:)
    h = super(hash: hash) || {} # 必要なのか？
    if
      hash[:my_time_minute].present? and
      hash[:my_time_second].present? and
      hash[:opponent_time_minute].present? and
      hash[:opponent_time_second].present?
    then
      h["time"] = "\
        #{hash[:my_time_minute]}\
        #{DELIMITER_TIME}\
        #{hash[:my_time_second]}\
        #{DELIMITER}\
        #{hash[:opponent_time_minute]}\
        #{DELIMITER_TIME}\
        #{hash[:opponent_time_second]}\
      ".gsub(/(\s| )+/, '')
    end
    h.update(compose_pairs(hash: hash,
      stems: %w(ball_touch intercept retry jury_votes)))
    h.delete("jury_votes") unless hash["jury_votes"].presence.to_bool
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
      if h["ball_touch"].present?
        self.my_ball_touch, self.opponent_ball_touch =
          h["ball_touch"].to_s.split(DELIMITER)
      end
      if h["intercept"].present?
        self.my_intercept, self.opponent_intercept =
          h["intercept"].to_s.split(DELIMITER)
      end
      if h["retry"].present?
        self.my_retry, self.opponent_retry =
          h["retry"].to_s.split(DELIMITER)
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
