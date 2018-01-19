class GameDetail1st < GameDetail
  module Constant
    UNKNOWN_VALUE = "--".freeze
    UNKNOWN_VALUE_FOR_WIN      = "-W".freeze
    UNKNOWN_VALUE_FOR_LOSE     = "-L".freeze
    UNKNOWN_VALUE_FOR_BOTH_DSQ = "-B".freeze
  end
  Constant.freeze

  REX_DD   = /[0-9]{2}/ # Double Digit, 2桁数字
  REX_TIME = /([0-9\-]{2}\.[0-9\-][0-9\-WLB])-([0-9\-]{2}\.[0-9\-][0-9\-WLB])/

  attr_accessor :my_time_minute, :my_time_second,
    :opponent_time_minute, :opponent_time_second,
    :memo

  def self.additional_attr_symbols
    [
      :my_time_minute, :my_time_second,
      :opponent_time_minute, :opponent_time_second,
      :memo
    ]
  end

  def self.attr_syms_for_params
    s = super()
    s.concat( additional_attr_symbols )
  end

  def self.compose_properties(hash:, victory:)
    if
      hash[:my_time_minute].present? and
      hash[:my_time_second].present?
    then
      if REX_DD === hash[:my_time_second] then # 分入力なしでも正常値とする
        if REX_DD === hash[:my_time_minute] then
          my_time = Time.new(2038, 1, 1, 0,
            hash[:my_time_minute].to_i, hash[:my_time_second].to_i)
        else
          hash[:my_time_minute] = Constant::UNKNOWN_VALUE # 強制改変
          my_time = Time.new(2038, 1, 1, 0,
            0, hash[:my_time_second].to_i)
        end
      else
        hash[:my_time_minute] = Constant::UNKNOWN_VALUE
        case victory # 不明の場合は勝敗に応じた不明値を設定
        when Game::Constant::WIN      then
          hash[:my_time_second] = Constant::UNKNOWN_VALUE_FOR_WIN
        when Game::Constant::LOSE     then
          hash[:my_time_second] = Constant::UNKNOWN_VALUE_FOR_LOSE
        when Game::Constant::BOTH_DSQ then
          hash[:my_time_second] = Constant::UNKNOWN_VALUE_FOR_BOTH_DSQ
        else
          hash[:my_time_second] = Constant::UNKNOWN_VALUE_FOR_WIN
        end
      end
    end
    if
      hash[:opponent_time_minute].present? and
      hash[:opponent_time_second].present?
    then
      if REX_DD === hash[:opponent_time_second] then # 分入力なしでも正常値とする
        if REX_DD === hash[:opponent_time_minute] then
          opponent_time = Time.new(2038, 1, 1, 0,
            hash[:opponent_time_minute].to_i, hash[:opponent_time_second].to_i)
        else
          hash[:opponent_time_minute] = Constant::UNKNOWN_VALUE # 強制改変
          opponent_time = Time.new(2038, 1, 1, 0,
            0, hash[:opponent_time_second].to_i)
        end
      else
        hash[:opponent_time_minute] = Constant::UNKNOWN_VALUE
        case victory # 不明の場合は勝敗に応じた不明値を設定
        when Game::Constant::WIN      then
          hash[:opponent_time_second] = Constant::UNKNOWN_VALUE_FOR_WIN
        when Game::Constant::LOSE     then
          hash[:opponent_time_second] = Constant::UNKNOWN_VALUE_FOR_LOSE
        when Game::Constant::BOTH_DSQ then
          hash[:opponent_time_second] = Constant::UNKNOWN_VALUE_FOR_BOTH_DSQ
        else
          hash[:opponent_time_second] = Constant::UNKNOWN_VALUE_FOR_WIN
        end
      end
    end
    if my_time.present? and opponent_time.present? then
      if my_time > opponent_time then # 速い方を先に置く
        hash[:my_time_minute], hash[:opponent_time_minute] =
          hash[:opponent_time_minute], hash[:my_time_minute]
        hash[:my_time_second], hash[:opponent_time_second] =
          hash[:opponent_time_second], hash[:my_time_second]
      end
    end
    a = []
    if
      hash[:my_time_minute].present? and
      hash[:my_time_second].present? and
      hash[:opponent_time_minute].present? and
      hash[:opponent_time_second].present?
    then
      a.push(%Q["time":"\
        #{hash[:my_time_minute]}.#{hash[:my_time_second]}-\
        #{hash[:opponent_time_minute]}.#{hash[:opponent_time_second]}\
      "].gsub(/(\s| )+/, ''))
    end
    a.push(%Q["memo":"#{hash[:memo]}"]) if hash[:memo].present?
    j = ''
    for i in a
      j += ',' unless j.blank?
      j += i
    end
    '{' + j + '}'
  end

  def decompose_properties(victory)
    h = JSON.parse(self.properties)
    if h["time"].present? then
      dummy, my_time_ms, opponent_time_ms = h["time"].to_s.split(REX_TIME)
      self.my_time_minute, self.my_time_second =
        my_time_ms.to_s.split(".")
      if REX_DD === self.my_time_second then
        if REX_DD === self.my_time_minute then
          my_time = Time.new(2038, 1, 1, 0,
            self.my_time_minute, self.my_time_second)
        else
          my_time = Time.new(2038, 1, 1, 0,
            0, self.my_time_second)
        end
      else
        # 秒指定されていないときは強制的に両方UNKNOWN_VALUEにする
        self.my_time_minute, self.my_time_second =
          Constant::UNKNOWN_VALUE, Constant::UNKNOWN_VALUE
      end
      self.opponent_time_minute, self.opponent_time_second =
        opponent_time_ms.to_s.split(".")
      if REX_DD === self.opponent_time_second then
        if REX_DD === self.opponent_time_minute then
          opponent_time = Time.new(2038, 1, 1, 0,
            self.opponent_time_minute, self.opponent_time_second)
        else
          opponent_time = Time.new(2038, 1, 1, 0,
            0, self.opponent_time_second)
        end
      else
        # 秒指定されていないときは強制的に両方UNKNOWN_VALUEにする
        self.opponent_time_minute, self.opponent_time_second =
          Constant::UNKNOWN_VALUE, Constant::UNKNOWN_VALUE
      end
      if my_time.present? and opponent_time.present? then
        case victory
        when Game::Constant::WIN  then
          swap_properties if my_time > opponent_time
        when Game::Constant::LOSE then
          swap_properties if my_time < opponent_time
        end
      end
    end
    self.memo = h["memo"].presence || ''
  end

  private

  def swap_properties
    self.my_time_minute, self.opponent_time_minute =
      self.opponent_time_minute, self.my_time_minute
    self.my_time_second, self.opponent_time_second =
      self.opponent_time_second, self.my_time_second
  end

end
