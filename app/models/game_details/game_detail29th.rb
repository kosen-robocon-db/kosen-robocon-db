class GameDetail29th < GameDetail
  attr_accessor :my_height, :opponent_height

  def self.additional_attr_symbols
    [ :my_height, :opponent_height ]
  end

  def self.attr_syms_for_params
    s = super()
    s.concat( additional_attr_symbols )
  end

  def self.compose_properties(hash:)
    %Q[{"score":"#{hash[:my_height]}-#{hash[:opponent_height]}"}]
  end

  def decompose_properties
    h = JSON.parse(self.properties)
    self.my_height = h["score"].to_s.split(/-/)[0]
    self.opponent_height = h["score"].to_s.split(/-/)[1]
  end
end
