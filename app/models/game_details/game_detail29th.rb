class GameDetail29th < GameDetail
  # 完了課題(progress)
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
  # 勝敗
  #   砦の高さが高い方を勝ちとする。
  #   最高高さは全国大会2回戦第5試合の奈良対舞鶴戦で奈良のΔが320cmを築いた。
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
  STEMS = %w( robot_code gaining_point retry foul challenge jury_votes )

  UNKNOWN = GameDetail::Constant::UNKNOWN_VALUE

  REX_GPT = /\A([1-9][0-9]{,2}|0)?\z/ # 入力無しを許可
  REX_RT  = /\A([0-9]|#{UNKNOWN})\z/
  REX_F   = /\A([0-5]|#{UNKNOWN})\z/
  REX_P   = /\A[0-7]\z/
  REX_VT  = /\A([0-5]|#{UNKNOWN})\z/

  enum challenge: {
    # 何もチェックせず、得点が記載されていれば不明かどうかは判別できる。
    # unknown(0)は何も選択されなかったときとしているので設定しない。
    start:               1, # スタート
    lighthouse_building: 2, # 灯台建築
    departure:           3, # 出港
    island_landing:      4, # 島上陸
    continent_landing:   5, # 新大陸上陸
    fort_block_building: 6, # 砦建築（ブロック積まで）
    fort_symbol_setting: 7  # 砦建築（シンボル乗せて完成）
  }

  # hight -> gaining_point に変更
  attr_accessor :my_gaining_point, :opponent_gaining_point
  attr_accessor :my_retry,         :opponent_retry
  attr_accessor :my_foul,          :opponent_foul
  attr_accessor :my_challenge,     :opponent_challenge
  attr_accessor :jury_votes
  attr_accessor :my_jury_votes,    :opponent_jury_votes
  attr_accessor :memo

  # *_challengeのバリデーションは省略している。
  validates :my_gaining_point,       format: { with: REX_GPT }
  validates :opponent_gaining_point, format: { with: REX_GPT }
  validates :my_retry,               format: { with: REX_RT }
  validates :opponent_retry,         format: { with: REX_RT }
  validates :my_foul,                format: { with: REX_F }
  validates :opponent_foul,          format: { with: REX_F }
  validates :jury_votes, inclusion: { in: [ "true", "false", nil ] }
  with_options if: :jury_votes do
    validates :my_jury_votes,        format: { with: REX_VT }
    validates :opponent_jury_votes,  format: { with: REX_VT }
  end
  validates :memo, length: { maximum: MEMO_LEN }

  # DBにはないがpropertyに納めたいフォーム上の属性
  def self.additional_attr_symbols
    [
      :my_gaining_point,         :opponent_gaining_point,
      :my_retry,                 :opponent_retry,
      :my_foul,                  :opponent_foul,
      { :my_challenge => [] }, { :opponent_challenge => [] },
      :jury_votes,
      :my_jury_votes,            :opponent_jury_votes,
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
      hash[:my_gaining_point].blank? and
      hash[:opponent_gaining_point].present?
    then
      h["gaining_point"] = "\
        #{UNKNOWN}\
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
    h["challenge"] = "\
      #{self.encode(hash[:my_challenge])}\
      #{DELIMITER}\
      #{self.encode(hash[:opponent_challenge])}\
    ".gsub(/(\s| )+/, '')
    h.update(compose_pairs(hash: hash, stems: %w( retry foul jury_votes )))
    h.delete("jury_votes") unless hash["jury_votes"].presence.to_bool
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    super(robot: robot) do |h|
      if h["gaining_point"].present?
        self.my_gaining_point, self.opponent_gaining_point =
          h["gaining_point"].to_s.split(DELIMITER).map{|x| x.gsub(/_/, '')}
      end
      if h["retry"].present?
        self.my_retry, self.opponent_retry =
          h["retry"].to_s.split(DELIMITER)
      end
      if h["foul"].present?
        self.my_foul, self.opponent_foul =
          h["foul"].to_s.split(DELIMITER)
      end
      if h["challenge"].present?
        self.my_challenge, self.opponent_challenge =
          h["challenge"].to_s.split(DELIMITER).map{ |x| decode(x) }
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
