class GameDetail1st < GameDetail

  attr_accessor :my_time, :opponent_time

  def self.additional_attr_symbols
    [ :my_time, :opponent_time ]
  end

end
