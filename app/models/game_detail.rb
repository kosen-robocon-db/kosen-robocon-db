class GameDetail < ApplicationRecord

  # 現状、大会毎にモデルを分けているが、
  # 工夫すればこのGameDetailモデルだけで済むのではないか？
  # 詳細用のビューは大会毎に用意しておくのは変らないが・・・
  # 30回全ての詳細が揃うまでは現行の方法で実装していく

  module Constant
    UNKNOWN_VALUE = "__"
  end

  STEMS          = %w( robot_code )
  DELIMITER      = "-"
  DELIMITER_TIME = ":"
  UNKNOWN        = "#{Constant::UNKNOWN_VALUE}"
  REX_MS         = /([0-5][0-9]|#{UNKNOWN})/
  REX_SC         = /(#{UNKNOWN}|-\d*|\d*)-(#{UNKNOWN}|-\d*|\d*)/
  MEMO_LEN       = 256

  serialize :properties, JSON
  after_initialize :reset_swap_state

  attr_accessor :my_robot_code, :opponent_robot_code, :victory, :memo

  scope :order_default, -> { order("number asc") }
  scope :order_csv, -> { order(game_code: :asc, number: :asc) }
    # インデックスでASC指定はできないのか？

  def self.additional_attr_symbols
    []
  end

  def self.attr_syms_for_params
    s = [ :id, :number, :_destroy ]
    s.concat( additional_attr_symbols )
  end

  def self.csv_headers
    # UTF-8出力される
    [ "試合コード", "試合番号（再試合）", "属性(JSON)" ]
  end

  def self.csv_column_syms
    [ :game_code, :number, :properties ]
  end

  def self.compose_properties(hash:)
    if hash[:my_robot_code].present? and hash[:opponent_robot_code].present?
      { "robot" => "#{hash[:my_robot_code]}-#{hash[:opponent_robot_code]}" }
    end
  end

  def stems
    STEMS
  end

  def decompose_properties(robot:)
    h = JSON.parse(self.properties)
    if h["robot"].present? then # 必ずrobotのコードがある前提だが・・・
      self.my_robot_code, self.opponent_robot_code =
        h["robot"].to_s.split(DELIMITER)
    end
    yield h
    # swap_properties(stems) unless robot.code.to_i == self.my_robot_code.to_i
    swap_properties unless robot.code.to_i == self.my_robot_code.to_i
  end

  def swap_properties(attribute_stems = STEMS)
    attribute_stems.each do |s|
      # a,b = b,a が可能ではないので、変数を一つ使用して実装
      b = self.send("my_#{s}")
      self.send("my_#{s}=", self.send("opponent_#{s}"))
      self.send("opponent_#{s}=", b)
    end
    @swapped = true
  end

  private

  # 更新時、left_robot_codeとright_robot_codeの内容（位置ではない）に変化がなければ
  # 更新前のleft_robot_codeとright_robot_code、及びproperties内の左右の位置のままで
  # 値だけを更新したかったが、その実装をしなくてもいまのところ害はないので、
  # propertiesの左右交換したことを示す状態フラグを実装するに留めている。
  def reset_swap_state
    @swapped = false
  end

end
