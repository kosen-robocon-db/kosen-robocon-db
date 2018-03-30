class GameDetail20th < GameDetail
  # 場外にはみ出たなどの反則をすると反則一つにつき旗を一本減らされる
  # 旗が5本しかないので反則を5回すると負け？
  # 延長戦は最初に1本以上の旗を獲ったほうが勝ち（サドンデス？）
  # リトライは設定されてないんじゃないか？

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code flag penalty union retry jury_votes )

  REX_F  = /[0-5]|#{GameDetail::Constant::UNKNOWN_VALUE}/ # 旗の数
  REX_P  = /[0-5]|#{GameDetail::Constant::UNKNOWN_VALUE}/ # 反則の数
  REX_RT = /[0-1]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_VT = /[0-5]|#{GameDetail::Constant::UNKNOWN_VALUE}/

  # Vホールのように条件を満足すれば即勝利となったときの試合決着時間は
  # special_time_minute/secondとはせず、time_minute/secondとして
  # 他の試合決着時間を記録する大会の変数名と合わせている。
  attr_accessor :my_flag,       :opponent_flag
  attr_accessor :my_penalty,    :opponent_penalty
  attr_accessor :my_union,      :opponent_union
  attr_accessor :my_retry,      :opponent_retry
  attr_accessor :special_win, :time_minute, :time_second
  attr_accessor :extra_time
  attr_accessor :jury_votes,
  attr_accessor :my_jury_votes, :opponent_jury_votes
  attr_accessor :memo

  validates :my_flag,               format: { with: REX_F }
  validates :opponent_flag,         format: { with: REX_F }
  validates :my_penalty,            format: { with: REX_P }
  validates :opponent_penalty,      format: { with: REX_P }
  validates :my_union,       inclusion: { in: [ "true", "false", nil ] }
  validates :opponent_union, inclusion: { in: [ "true", "false", nil ] }
  validates :my_retry,              format: { with: REX_RT }
  validates :opponent_retry,        format: { with: REX_RT }
  with_options if: :special_win do
    validates :time_minute,         format: { with: REX_MS }
    validates :time_second,         format: { with: REX_MS }
  end
  validates :extra_time,     inclusion: { in: [ "true", "false", nil ] }
  with_options if: :jury_votes do
    validates :my_jury_votes,       format: { with: REX_VT }
    validates :opponent_jury_votes, format: { with: REX_VT }
  end
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_flag,       :opponent_flag,
      :my_penalty,    :opponent_penalty,
      :my_union,      :opponent_union,
      :my_retry,      :opponent_retry,
      :special_win, :time_minute, :time_second,
      :extra_time,
      :jury_votes,
      :my_jury_votes, :opponent_jury_votes,
      :memo
    ]
  end

  def stems
    STEMS
  end

  def self.compose_properties(hash:)
    if # compose_pairsで拾えないunionのケースに対応
      hash[:my_union].present? and
      hash[:opponent_union].blank?
    then
      hash[:opponent_union] = "false"
    end
    if # compose_pairsで拾えないunionのケースに対応
      hash[:my_union].blank? and
      hash[:opponent_union].present?
    then
      hash[:my_union] = "false"
    end
    h = compose_pairs(hash: hash, stems: STEMS)
    if
      hash[:special_win].presence.to_bool and
      hash[:time_minute].present? and
      hash[:time_second].present?
    then
      h["special_win"] = "\
        #{hash[:time_minute]}\
        #{DELIMITER_TIME}\
        #{hash[:time_second]}\
      ".gsub(/(\s| )+/, '')
    end
    h["extra_time"] = "true"           if hash[:extra_time].present?
    h.delete("jury_votes") unless hash["jury_votes"].presence.to_bool
    h["memo"]       = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["flag"].present?
        self.my_flag, self.opponent_flag =
          h["flag"].to_s.split(REX_SC)[1..-1]
      end
      if h["penalty"].present?
        self.my_penalty, self.opponent_penalty =
          h["penalty"].to_s.split(DELIMITER)[1..-1]
      end
      if h["union"].present?
        self.my_union, self.opponent_union =
          h["union"].to_s.split(DELIMITER).map{ |x| x.to_bool }
      end
      self.my_retry, self.opponent_retry =
        h["retry"].to_s.split(DELIMITER) if h["retry"].present?
      if h["special_win"].present?
        self.special_win = true
        self.time_minute, self.time_second =
          h["special_win"].to_s.split(DELIMITER_TIME)
      end
      self.extra_time  = h["extra_time"].presence.to_bool || false
      if h["jury_votes"].present?
        self.jury_votes = true
        self.my_jury_votes, self.opponent_jury_votes =
          h["jury_votes"].to_s.split(DELIMITER)
      end
      self.memo        = h["memo"].presence               || ''
    end
  end

end
