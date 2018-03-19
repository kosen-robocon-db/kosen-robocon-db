class GameDetail14th < GameDetail

  # 北海道地区だけ引き分け時、
  #   条件勝ち（ショートケーキゾーンに建てる、灯に見立てた飾りを最上部につける）
  # リトライ1回だけ可能
  #   ビューでチェックボックスを利用するが、propertiesには回数を保存する
  # 延長戦1分、決着がつかなかった場合は審査員判定（地区全国ともに5人？）
  #   地区によっては延長戦がなかったかもしれない（北海道地区は無かった？）
  # 減点はなさそうだ

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code gaining_point retry jury_votes )

  REX_GPT = /[0-9]|[1-7][0-9]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_RT  = /[0-1]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_VT  = /[0-5]|#{GameDetail::Constant::UNKNOWN_VALUE}/

  attr_accessor :my_gaining_point, :opponent_gaining_point
  attr_accessor :my_retry, :opponent_retry
  attr_accessor :extra_time
  attr_accessor :jury_votes, :my_jury_votes, :opponent_jury_votes
  attr_accessor :memo

  validates :my_gaining_point,       format: { with: REX_GPT }
  validates :opponent_gaining_point, format: { with: REX_GPT }
  validates :my_retry,               format: { with: REX_RT }
  validates :opponent_retry,         format: { with: REX_RT }
  validates :extra_time, inclusion: { in: [ "true", "false", nil ] }
  with_options if: :jury_votes do
    validates :my_jury_votes,        format: { with: REX_VT }
    validates :opponent_jury_votes,  format: { with: REX_VT }
  end
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_gaining_point, :opponent_gaining_point,
      :my_retry,         :opponent_retry,
      :extra_time,
      :jury_votes, :my_jury_votes, :opponent_jury_votes,
      :memo
    ]
  end

  def stems
    STEMS
  end

  def self.compose_properties(hash:)
    h = super(hash: hash) || {} # robot_code
    h.update(compose_pairs(hash: hash, stems: STEMS))
    h["extra_time"] = "true" if hash[:extra_time].present?
    h.delete("jury_votes") unless hash["jury_votes"].presence.to_bool
    h["memo"]       = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["gaining_point"].present?
        self.my_gaining_point, self.opponent_gaining_point =
          h["gaining_point"].to_s.split(REX_SC)[1..-1]
      end
      self.my_retry, self.opponent_retry =
        h["retry"].to_s.split(DELIMITER) if h["retry"].present?
      self.extra_time = h["extra_time"].presence.to_bool || false
      self.jury_votes = h["jury_votes"].presence.to_bool || false
      if h["jury_votes"].present?
        self.jury_votes = true
        self.my_jury_votes, self.opponent_jury_votes =
          h["jury_votes"].to_s.split(DELIMITER)
      end
      self.memo       = h["memo"].presence               || ''
    end
  end

end
