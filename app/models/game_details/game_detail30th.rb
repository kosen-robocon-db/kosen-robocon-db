class GameDetail30th < GameDetail
  UNKNOWN_VALUE_FOR_LOSE = -99
  UNKNOWN_VALUE_FOR_WIN  =  99
  REX = /([-]?[0-9]+)-([-]?[0-9])/

  attr_accessor :my_robot_baloon, :opponent_robot_baloon,
   :my_base_baloon, :opponent_base_baloon,
   :jury_votes, :my_jury_votes, :opponent_jury_votes,
   :time

  validates :my_robot_baloon, numericality: {
    only_integer: true,
    greater_than_or_equal_to: UNKNOWN_VALUE_FOR_LOSE,
    less_than_or_equal_to:    UNKNOWN_VALUE_FOR_WIN
  }
  validates :opponent_robot_baloon, numericality: {
    only_integer: true,
    greater_than_or_equal_to: UNKNOWN_VALUE_FOR_LOSE,
    less_than_or_equal_to:    UNKNOWN_VALUE_FOR_WIN
  }
  validates :my_base_baloon, numericality: {
    only_integer: true,
    greater_than_or_equal_to: UNKNOWN_VALUE_FOR_LOSE,
    less_than_or_equal_to:    UNKNOWN_VALUE_FOR_WIN
  }
  validates :opponent_base_baloon, numericality: {
    only_integer: true,
    greater_than_or_equal_to: UNKNOWN_VALUE_FOR_LOSE,
    less_than_or_equal_to:    UNKNOWN_VALUE_FOR_WIN
  }
  # validates :time, numericality: {
  #   only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10
  # }
  # 審査員判定の票に関しては、今回一つもなかったので、改善を施していない。
  with_options if: :jury_votes do
    validates :my_jury_votes,       numericality: {
      only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5
    }
    validates :opponent_jury_votes, numericality: {
      only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5
    }
  end

  def self.additional_attr_symbols
    [
      :my_robot_baloon, :opponent_robot_baloon,
      :my_base_baloon, :opponent_base_baloon,
      :jury_votes, :my_jury_votes, :opponent_jury_votes,
      :time
    ]
  end

  def self.attr_syms_for_params
    s = super()
    s.concat( additional_attr_symbols )
  end

  # SRP(Single Responsibility Principle, 単一責任原則)に従っていないが
  # このクラス内で実装する。
  def self.compose_properties(hash:, victory:)
    # 風船の個数が不明な場合、不明であることだけでは勝敗情報があってもどちらの個数か
    # 判別できないので、予め勝利して不明の値、または負けて不明の値を入れておく。
    # 不明を入力したときの値は最初全て負けた場合の不明の値となっているからである。
    if victory == "true" then # booleanではないことに注意。booleanにして欲しい。
      if hash[:my_base_baloon].to_i == UNKNOWN_VALUE_FOR_LOSE then
        hash[:my_base_baloon] = "#{UNKNOWN_VALUE_FOR_WIN}"
      end
      if hash[:my_robot_baloon].to_i == UNKNOWN_VALUE_FOR_LOSE then
        hash[:my_robot_baloon] = "#{UNKNOWN_VALUE_FOR_WIN}"
      end
    end

    # 風船の数で、値をそのままか交換を決定（優勢な方を先に配置。勝敗は関係ない。）
    # リフクレションでもっと簡潔に書けないか？
    if
      hash[:my_base_baloon] < hash[:opponent_base_baloon] ||
      hash[:my_robot_baloon] < hash[:opponent_robot_baloon] ||
      hash[:my_jury_votes] < hash[:opponent_jury_votes]
    then
      hash[:my_base_baloon], hash[:opponent_base_baloon] =
        hash[:opponent_base_baloon], hash[:my_base_baloon]
      hash[:my_robot_baloon], hash[:opponent_robot_baloon] =
        hash[:opponent_robot_baloon], hash[:my_robot_baloon]
      hash[:my_jury_votes], hash[:opponent_jury_votes] =
        hash[:opponent_jury_votes], hash[:my_jury_votes]
    end

    a = []
    a.push(%Q["base-baloon":"#{hash[:my_base_baloon]}-#{hash[:opponent_base_baloon]}"]) if
      not hash[:my_base_baloon].blank? and not hash[:opponent_base_baloon].blank?
    a.push(%Q["robot-baloon":"#{hash[:my_robot_baloon]}-#{hash[:opponent_robot_baloon]}"]) if
      not hash[:my_robot_baloon].blank? and not hash[:opponent_robot_baloon].blank?
    a.push(%Q["jury_votes":"#{hash[:my_jury_votes]}-#{hash[:opponent_jury_votes]}"]) if
      not hash[:my_jury_votes].blank? and not hash[:opponent_jury_votes].blank?
    a.push(%Q["time":"#{hash[:time]}"]) if
      not hash[:time].blank?
    j = ''
    for i in a
      j += ',' if not j.blank?
      j += i
    end
    '{' + j + '}'
  end

  # SRP(Single Responsibility Principle, 単一責任原則)に従っていないが
  # このクラス内で実装する。
  def decompose_properties(victory)
    h = JSON.parse(self.properties)
    # dummyが必要ないsplitメソッドに与える正規表現(REX)を募集中
    dummy, self.my_robot_baloon, self.opponent_robot_baloon =
      h["robot-baloon"].to_s.split(REX) if not h["robot-baloon"].blank?
    dummy, self.my_base_baloon, self.opponent_base_baloon =
      h["base-baloon"].to_s.split(REX) if not h["base-baloon"].blank?
    self.jury_votes = h["jury_votes"].blank? ? false : true
    dummy, self.my_jury_votes, self.opponent_jury_votes =
      h["jury_votes"].to_s.split(REX) if not h["jury_votes"].blank?
    self.time = h["time"].to_s if not h["time"].blank?

    # 風船の数と審査委員判定より、値をそのままか交換かを決定
    # game_detailsオブジェクトのチームに対する一部の属性は
    # gameオブジェクトのvictory属性の勝敗から導き出される勝ち負けチーム情報に従属する。
    # 以下の処理はlow(自分)-high(相手)で格納されている情報を
    # high(自分)-low(相手)に変換する必要があるかどうかを調べてから変換している。
    case victory
    when "true"
      swap_properties if
        self.my_base_baloon.to_i < self.opponent_base_baloon.to_i ||
        self.my_robot_baloon.to_i < self.opponent_robot_baloon.to_i ||
          (
            !self.my_jury_votes.blank? && !self.opponent_jury_votes.blank? &&
              self.my_jury_votes.to_i < self.opponent_jury_votes.to_i
          )
    when "false"
      swap_properties if
        self.my_base_baloon.to_i > self.opponent_base_baloon.to_i ||
        self.my_robot_baloon.to_i > self.opponent_robot_baloon.to_i ||
          (
            !self.my_jury_votes.blank? && !self.opponent_jury_votes.blank? &&
              self.my_jury_votes.to_i > self.opponent_jury_votes.to_i
          )
    end

    # フォームではUNKNOWN_VALUE_FOR_LOSEを不明としているのでその変換
    self.my_base_baloon = "#{UNKNOWN_VALUE_FOR_LOSE}" if
      self.my_base_baloon.to_i == UNKNOWN_VALUE_FOR_WIN
    self.opponent_base_baloon = "#{UNKNOWN_VALUE_FOR_LOSE}" if
      self.opponent_base_baloon.to_i == UNKNOWN_VALUE_FOR_WIN
    self.my_robot_baloon = "#{UNKNOWN_VALUE_FOR_LOSE}" if
      self.my_robot_baloon.to_i == UNKNOWN_VALUE_FOR_WIN
    self.opponent_robot_baloon = "#{UNKNOWN_VALUE_FOR_LOSE}" if
      self.opponent_robot_baloon.to_i == UNKNOWN_VALUE_FOR_WIN
  end

  private

  def swap_properties
    self.my_robot_baloon, self.opponent_robot_baloon =
      self.opponent_robot_baloon, self.my_robot_baloon
    self.my_base_baloon, self.opponent_base_baloon =
      self.opponent_base_baloon, self.my_base_baloon
    self.my_jury_votes, self.opponent_jury_votes =
      self.opponent_jury_votes, self.my_jury_votes
  end
end
