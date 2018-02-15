class GameDetail1st < GameDetail
  module Constant
    UNKNOWN_VALUE = "__" # DB/モデル用。"--"では正規表現利用の文字列区切りで面倒。
  end

  DELIMITER      = "-"
  DELIMITER_TIME = ":"
  REX       = /#{DELIMITER}|#{DELIMITER_TIME}/
  REX_MS    = /([0-5][0-9]|#{Constant::UNKNOWN_VALUE})/

  attr_accessor :my_time_minute, :my_time_second,
    :opponent_time_minute, :opponent_time_second,
    :memo

  # 下記の*_time_minnute, *_time_second検証は現バージョンんでは必要ないかもしれない。
  with_options if: :my_time_minute do
    validates :my_time_minute, format: { with: REX_MS }
  end
  with_options if: :my_time_second do
    validates :my_time_second, format: { with: REX_MS }
  end
  with_options if: :opponent_time_minute do
    validates :opponent_time_minute, format: { with: REX_MS }
  end
  with_options if: :opponent_time_second do
    validates :opponent_time_second, format: { with: REX_MS }
  end
  validates :memo, length: { maximum: 255 }

  def self.additional_attr_symbols
    [
      :my_time_minute, :my_time_second,
      :opponent_time_minute, :opponent_time_second,
      :memo
    ]
  end

  def self.attr_syms_for_params
    s = super() || []
    s.concat( additional_attr_symbols )
  end

  def self.compose_properties(hash:)
    h = super(hash: hash) || {}
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
    h["memo"] = "#{hash[:memo]}" if hash[:memo].present?
    return h
  end

  def decompose_properties(robot:)
    h = JSON.parse(self.properties)
    if h["robot"].present? then # テーブルカラムにすべきでは？ 必ずコードがある前提
      self.my_robot_code, self.opponent_robot_code =
        h["robot"].to_s.split(DELIMITER)
    end # テーブルカラムにすれば全ての継承クラスで同じコードを書かなくて済むはず！

    if h["time"].present? then
      self.my_time_minute, self.my_time_second,
        self.opponent_time_minute, self.opponent_time_second =
          h["time"].to_s.split(REX) # この時点ではREにマッチしたとしている
    end
    self.memo = h["memo"].presence || ''

    # my_robot_code側から見ているので、ロボットコード異なる場合は左右の値を交換する
    roots = %w( robot_code time_minute time_second )
    swap_properties(roots) unless robot.code.to_i == self.my_robot_code.to_i
  end

end
