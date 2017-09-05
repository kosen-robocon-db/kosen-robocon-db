class GameDetail29th < GameDetail

  # store :properties, JSON, accessors: %i(score)

  attr_accessor :my_height, :opponent_height

  def self.additional_attr_symbols
    # [ :my_height, :opponent_height, :_destroy ]
    [ :my_height, :opponent_height ]
  end

  def self.properties(h)
    %Q[{"score":"#{h[:my_height]}-#{h[:opponent_height]}"}]
  end

end
