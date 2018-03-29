class GameDetail19th < GameDetail

  # 課題(progress)
  #   以下は完了ではなく最中
  #   0: スタートゾーン
  #   1: お堀越え（お堀の底に触れるとファウル）
  #   2: シーソー（）
  #   3: スラローム（？）
  #   4: 縄跳び（飛べなかったらやり直し？ゾーンからはみ出したら？）
  #   5: ふるさとゴール
  # 特別勝利条件(sudden death)
  #   ふるさとゴールをした時点で勝ち
  # ファイルと失格
  #   ファウルしたら基本的には前のゾーンをからやり直し。三回で失格。
  #   オブジェがロボットに触れたらファウル
  # リトライ
  #   1回だけ可能
  # 両者ふるさとゴールできず同じゾーンだった場合
  #   審査員判定？（地区3名、全国？名）

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code retry progress jury_votes )

  REX_RT = /[0-1]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_P  = /[0-5]|#{GameDetail::Constant::UNKNOWN_VALUE}/
  REX_VT = /[0-5]|#{GameDetail::Constant::UNKNOWN_VALUE}/

  # Vホールのように条件を満足すれば即勝利となったときの試合決着時間は
  # special_time_minute/secondとはせず、time_minute/secondとして
  # 他の試合決着時間を記録する大会の変数名と合わせている。
  attr_accessor :my_retry,             :opponent_retry
  attr_accessor :progress,   :my_progress,   :opponent_progress
  attr_accessor :special_win, :time_minute, :time_second
  attr_accessor :jury_votes, :my_jury_votes, :opponent_jury_votes
  attr_accessor :memo

  validates :my_retry,                  format: { with: REX_RT }
  validates :opponent_retry,            format: { with: REX_RT }
  with_options if: :progress do
    validates :my_progress,             format: { with: REX_P }
    validates :opponent_progress,       format: { with: REX_P }
  end
  with_options if: :special_win do
    validates :time_minute, format: { with: REX_MS }
    validates :time_second, format: { with: REX_MS }
  end
  with_options if: :jury_votes do
    validates :my_jury_votes,           format: { with: REX_VT }
    validates :opponent_jury_votes,     format: { with: REX_VT }
  end
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_retry, :opponent_retry,
      :progress,   :my_progress,   :opponent_progress,
      :special_win, :time_minute, :time_second,
      :jury_votes, :my_jury_votes, :opponent_jury_votes,
      :memo
    ]
  end

  enum progresses: {
    start_zone:  0, # スタートゾーン
    moat_zone:   1, # お堀越え（お堀の底に触れるとファウル）
    seesaw_zone: 2, # シーソー（）
    slalom_zone: 3, # スラローム（？）
    rope_zone:   4, # 縄跳び（飛べなかったらやり直し？ゾーンからはみ出したら？）
    goal_zone:   5  # ふるさとゴール
  }

  def stems
    STEMS
  end

  def self.compose_properties(hash:)
    h = super(hash: hash) || {} # 必要なのか？
    h.update(compose_pairs(hash: hash, stems: STEMS))
    h.delete("progress")   unless hash["progress"].presence.to_bool
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
    h.delete("jury_votes") unless hash["jury_votes"].presence.to_bool
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      self.my_retry, self.opponent_retry =
        h["retry"].to_s.split(DELIMITER) if h["retry"].present?
      if h["progress"].present?
        self.progress = true
        self.my_progress, self.opponent_progress =
          h["progress"].to_s.split(DELIMITER)
      end
      if h["special_win"].present?
        self.special_win = true
        self.time_minute, self.time_second =
          h["special_win"].to_s.split(DELIMITER_TIME)
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
