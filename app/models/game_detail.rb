class GameDetail < ApplicationRecord

  # 現状、大会毎にモデルを分けているが、
  # 工夫すればこのGameDetailモデルだけで済むのではないか？
  # 詳細用のビューは大会毎に用意しておくのは変らないが・・・
  # 30回全ての詳細が揃うまでは現行の方法で実装していく

  # 理想的には、例えば減点などがなく得点だけの大会でも
  # gaining_pointではなくtotal_point、もしくは新しくresultとして
  # porpertiesに持たせ、なるべく全回大会で統一し、統計処理し易くすべきだが、
  # どのような構造でも引き継いだ開発者でも現状の情報の構造で
  # 様々な開発展開ができると判断し、このままにしておく。
  # *_pointではなくtimeの大会もあるし・・・

  module Constant
    UNKNOWN_VALUE     = "__"
  end

  STEMS               = %w( robot_code )
  DELIMITER           = "-"
  DELIMITER_TIME      = ":"
  DELIMITER_TIME_PAIR = /#{DELIMITER}|#{DELIMITER_TIME}/
  UNKNOWN             = "#{Constant::UNKNOWN_VALUE}"
  REX_MS              = /\A[0-5][0-9]|#{UNKNOWN}\z/
  REX_SC              = /\A(#{UNKNOWN}|-\d*|\d*)-(#{UNKNOWN}|-\d*|\d*)\z/

  MEMO_LEN            = 256

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

  def stems
    STEMS
  end

  def self.compose_properties(hash:)
    if hash[:my_robot_code].present? and hash[:opponent_robot_code].present?
      {"robot_code" =>
        "#{hash[:my_robot_code]}#{DELIMITER}#{hash[:opponent_robot_code]}"}
    end
  end

  def decompose_properties(robot:)
    return if self.properties.nil?
    h = JSON.parse(self.properties)
    if h["robot_code"].present? then # 必ずrobotのコードがある前提だが・・・
      self.my_robot_code, self.opponent_robot_code =
        h["robot_code"].to_s.split(DELIMITER)
    end
    yield h
    swap_properties unless robot.code.to_i == self.my_robot_code.to_i
  end

  def swap_properties(attribute_stems = stems)
    attribute_stems.each do |s|
      # a,b = b,a が可能ではないので、変数を一つ使用して実装
      b = self.send("my_#{s}")
      self.send("my_#{s}=", self.send("opponent_#{s}"))
      self.send("opponent_#{s}=", b)
    end
    @swapped = true
  end

  def self.compose_pairs(hash:, stems:)
    h = {}
    stems.each do |stm|
      my_sym, opponent_sym = "my_#{stm}".to_sym, "opponent_#{stm}".to_sym
      if hash[my_sym].present? and hash[opponent_sym].present?
        h["#{stm}"] = "#{hash[my_sym]}#{DELIMITER}#{hash[opponent_sym]}"
      end
    end
    return h
  end

  def self.compose_time(hash:)
    h = {}
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
    if
      hash[:time_minute].present? and
      hash[:time_second].present?
    then
      h["time"] = "\
        #{hash[:time_minute]}\
        #{DELIMITER_TIME}\
        #{hash[:time_second]}\
      ".gsub(/(\s| )+/, '')
    end
    return h
  end

  private

  # 更新時、left_robot_codeとright_robot_codeの内容（位置ではない）に変化がなければ
  # 更新前のleft_robot_codeとright_robot_code、及びproperties内の左右の位置のままで
  # 値だけを更新したかったが、その実装をしなくてもいまのところ害はないので
  # （必要のないDBのUPDATEの回数が増えるが）
  # propertiesの左右交換したことを示す状態フラグを実装するに留めている。
  def reset_swap_state
    @swapped = false
  end

  # 以下は第30回までで第22回と第29回でしか利用していない。

  # 与えられた配列arrayの先頭から要素を一つずつ調べている。
  # 調べている要素がゼロから始まらない十進数文字列であれば
  # 整数値に変換後1を減じた数を2の指数としてそのべき乗を求める。
  # それぞれの要素の2のべき乗を全て足したものを返す。
  # self.decode(["3","0","1"])
  # => 5
  # このメソッドがクラスメソッドであるのは、
  # オブジェクト生成前に呼び出されるからである。
  def self.encode(array=[])
    a = 0
    if array.present? and array.instance_of?(Array) # instance_ofだけでいいはず？
      array.each { |v| a += 2 ** ( v.to_i - 1 ) if v =~ /\A[1-9][0-9]*\z/ }
    end
    a
  end

  # 与えられた十進数文字列を二進数文字列に変換後に先頭から一文字ずつ調べている。
  # 調べている文字が'1'であれば二進数文字列変換時の長さから現在調べている文字の
  # インデックスを引いたものを配列に格納し、調べ終わったらその配列を返す。
  # a=GameDetail29th.new
  # a=decode("7")
  # => ["3","2","1"]
  def decode(r='0')
    a = Array.new
    if r.present?
      s = r.to_i.to_s(2)
      s.split(//).each_with_index do |v, i|
        a.push((s.length - i).to_s) if v =~ /\A1\z/
      end
    end
    a
  end

end
