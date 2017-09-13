class GameDetail29th < GameDetail
  attr_accessor :my_height, :opponent_height,
    :judge, :judge_to_me, :judge_to_opponent

  def self.additional_attr_symbols
    [
      :my_height, :opponent_height,
      :judge, :judge_to_me, :judge_to_opponent
    ]
  end

  def self.attr_syms_for_params
    s = super()
    s.concat( additional_attr_symbols )
  end

  def self.compose_properties(hash:)
    # %Q[{"score":"#{hash[:my_height]}-#{hash[:opponent_height]}"}]
    a = []
    a.push(%Q["score":"#{hash[:my_height]}-#{hash[:opponent_height]}"]) if
      not hash[:my_height].blank? and not hash[:opponent_height].blank?
    a.push(%Q["judge":"#{hash[:judge_to_me]}-#{hash[:judge_to_opponent]}"]) if
      not hash[:judge_to_me].blank? and not hash[:judge_to_opponent].blank?
    j = ''
    for i in a
      j += ',' if not j.blank?
      j += i
    end
    '{' + j + '}'
  end

  def decompose_properties
    logger.debug(">>>> porperties: #{self.properties}")
    h = JSON.parse(self.properties)
    self.my_height =
      h["score"].to_s.split(/-/)[0] if not h["score"].blank?
    self.opponent_height =
      h["score"].to_s.split(/-/)[1] if not h["score"].blank?
    self.judge_to_me =
      h["judge"].to_s.split(/-/)[0] if not h["judge"].blank?
    self.judge_to_opponent =
      h["judge"].to_s.split(/-/)[1] if not h["judge"].blank?
  end
end
