class GameDetail18th < GameDetail
  # 反則があると罰鯛で一つ前のゾーンからやり直し（罰退）・・・実装すべきか？
  # 乗り越えた障害（進捗）：
  #   0:スタートゾーン
  #   1:梯子潜り
  #   2:平均台渡り
  #   3:ハードル越え
  #   4:バトン渡し
  #   5:壁登り
  #   6:バトンゴール
  # リトライはスタート地点からやり直し
  # 同じゾーンで同じ障害乗り越え状態であれば、
  # ロボットの最後尾がゴールに近いチームの勝ち（計測判定、0.5cm刻み）
  # スタート地点からバトン受け渡しゾーンまで何ｍ？

  # my_robot_code側から見ているので、
  # ロボットコード異なる場合は交換したい左右の値の語幹を書いておく
  STEMS = %w( robot_code time_minute time_second retry foul progress distance
    jury_votes )

  REX_P  = /\A[0-7]\z/
  REX_D  = /\A(([1-9]\d{,1}|0)(\.\d{,2}(0|5){,1})?)?\z/ # 何も入力しないを許す。
  REX_RT = /\A([0-1]|#{UNKNOWN})\z/
  REX_F  = /\A([0-9]|#{UNKNOWN})\z/
  REX_VT = /\A([0-5]|#{UNKNOWN})\z/

  enum progress: {
    unknown:       0, # 不明 ビューでは"--"
    start:         1, # スタート
    ladder_wicket: 2, # 梯子潜り
    balance_beam:  3, # 平均台渡り
    hardle_cross:  4, # ハードル越え
    baton_passing: 5, # バトン渡し
    wall_clibming: 6, # 壁登り
    baton_goal:    7  # バトンゴール
  }

  attr_accessor :my_time_minute, :opponent_time_minute
  attr_accessor :my_time_second, :opponent_time_second
  attr_accessor :my_retry,       :opponent_retry
  attr_accessor :my_foul,        :opponent_foul
  attr_accessor :progress
  attr_accessor :my_progress,    :opponent_progress
  attr_accessor :distance
  attr_accessor :my_distance,    :opponent_distance
  attr_accessor :jury_votes
  attr_accessor :my_jury_votes,  :opponent_jury_votes
  attr_accessor :memo

  validates :my_time_minute,        format: { with: REX_MS }
  validates :opponent_time_minute,  format: { with: REX_MS }
  validates :my_time_second,        format: { with: REX_MS }
  validates :opponent_time_second,  format: { with: REX_MS }
  validates :my_retry,              format: { with: REX_RT }
  validates :opponent_retry,        format: { with: REX_RT }
  validates :my_foul,               format: { with: REX_F }
  validates :opponent_foul,         format: { with: REX_F }
  with_options if: :progress do
    validates :my_progress,         format: { with: REX_P }
    validates :opponent_progress,   format: { with: REX_P }
  end
  with_options if: :distance do
    validates :my_distance,         format: { with: REX_D }
    validates :opponent_distance,   format: { with: REX_D }
  end
  with_options if: :jury_votes do
    validates :my_jury_votes,       format: { with: REX_VT }
    validates :opponent_jury_votes, format: { with: REX_VT }
  end
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにカラムはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_time_minute, :opponent_time_minute,
      :my_time_second, :opponent_time_second,
      :my_retry,       :opponent_retry,
      :my_foul,        :opponent_foul,
      :progress,
      :my_progress,    :opponent_progress,
      :distance,
      :my_distance,    :opponent_distance,
      :jury_votes,
      :my_jury_votes,  :opponent_jury_votes,
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
    h = super(hash: hash) || {}
    h.update(compose_time(hash: hash))
    h.update(compose_pairs(hash: hash, stems: %w( retry foul progress )))
    # compose_pairsで拾えないdistance(入力なし)に対応
    if
      hash[:my_distance].present? and
      hash[:opponent_distance].present?
    then
      h["distance"] = "\
        #{hash[:my_distance]}\
        #{DELIMITER}\
        #{hash[:opponent_distance]}\
      ".gsub(/(\s| )+/, '')
    end
    if
      hash[:my_distance].present? and
      hash[:opponent_distance].blank?
    then
      h["distance"] = "\
        #{hash[:my_distance]}\
        #{DELIMITER}\
        #{UNKNOWN}\
      ".gsub(/(\s| )+/, '')
    end
    if
      hash[:my_distance].blank? and
      hash[:opponent_distance].present?
    then
      h["distance"] = "\
        #{UNKNOWN}\
        #{DELIMITER}\
        #{hash[:opponent_distance]}\
      ".gsub(/(\s| )+/, '')
    end
    h.update(compose_pairs(hash: hash, stems: %w( jury_votes )))
    h.delete("progress")   unless hash["progress"].presence.to_bool
    h.delete("distance")   unless hash["distance"].presence.to_bool
    h.delete("jury_votes") unless hash["jury_votes"].presence.to_bool
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["time"].present? then
        self.my_time_minute, self.my_time_second,
          self.opponent_time_minute, self.opponent_time_second =
            h["time"].to_s.split(DELIMITER_TIME_PAIR)
      end
      if h["retry"].present?
        self.my_retry, self.opponent_retry =
          h["retry"].to_s.split(DELIMITER)
      end
      if h["foul"].present?
        self.my_foul, self.opponent_foul =
          h["foul"].to_s.split(DELIMITER)
      end
      if h["progress"].present?
        self.progress = true
        self.my_progress, self.opponent_progress =
          h["progress"].to_s.split(DELIMITER)
      end
      if h["distance"].present?
        self.distance = true
        self.my_distance, self.opponent_distance =
          h["distance"].to_s.split(DELIMITER).map{|x| x.gsub(/#{UNKNOWN}/, '')}
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
