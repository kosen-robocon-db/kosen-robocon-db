class GameDetail14th < GameDetail

  # 北海道地区だけ引き分け時、
  #   条件勝ち（ショートケーキゾーンに建てる、灯に見立てた飾りを最上部につける）
  # リトライ1回だけ可能
  # 延長戦1分、決着がつかなかった場合は審査員判定（何人？）
  #   地区によっては延長戦がなかったかもしれない（北海道地区は無かった？）
  # 減点はなさそうだ

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  ROOTS = %w( robot_code point retry jury_votes )

  REX_PT = /[0-9]|[1-7][0-9]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_VT = /([0-5]|#{GameDetail::Constant::UNKNOWN_VALUE})/
    # 地区、全国ともに5人？（要確認）

  attr_accessor :my_point, :opponent_point
  attr_accessor :my_retry, :opponent_retry
  attr_accessor :extra_time
  attr_accessor :jury_votes, :my_jury_votes, :opponent_jury_votes
  attr_accessor :memo

  # validates に numericality: {} を指定したいところだが(分かり易いが)、
  # format: {} のほうが手間がかからないようなので、採用した。
  # 減点があったかどうか不明だが、得点だけを実装しておいた。
  validates :my_point, format: { with: REX_PT }
  validates :opponent_point, format: { with: REX_PT }
  with_options if: :jury_votes do
    validates :my_jury_votes, format: { with: REX_VT }
    validates :opponent_jury_votes, format: { with: REX_VT }
  end
  validates :memo, length: { maximum: 255 }

  # DBにはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_point, :opponent_point,
      :my_retry, :opponent_retry,
      :extra_time,
      :jury_votes, :my_jury_votes, :opponent_jury_votes,
      :memo
    ]
  end

  def roots
    ROOTS
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
    h["extra_time"] = "true" if hash[:extra_time].present?
    h.delete("jury_votes") unless hash["jury_votes"].present?
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["point"].present?
        self.my_point, self.opponent_point =
          h["point"].to_s.split(REX_SC)[1..-1]
      end
      self.extra_time = h["extra_time"].present? ? true : false
      self.jury_votes = h["jury_votes"].present? ? true : false
      self.my_jury_votes, self.opponent_jury_votes =
        h["jury_votes"].to_s.split(DELIMITER) if h["jury_votes"].present?
      self.memo = h["memo"].presence || ''
    end
  end

end
