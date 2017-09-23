json.array! @game_details do |detail|
  json.game_code detail.game_code
  json.number detail.number
  json.properties detail.properties
end
