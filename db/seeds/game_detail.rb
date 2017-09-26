require "csv"
CSV_FILE_PATH="db/seeds/csv/game_details.csv"
bulk_insert_data = []
if FileTest.exist?(CSV_FILE_PATH) then
  csv = CSV.read(CSV_FILE_PATH, headers: true)
  csv.each do |row|
    bulk_insert_data << GameDetail.new(
      game_code:  row[0],
      number:     row[1],
      properties: row[2]
    )
  end
else
  bulk_insert_data << GameDetail.new(game_code: 1291101, number: 1, properties: '{
    "score":"0-0",
    "judge":"3-0",
    "progress":"灯台-なし"
  }'.gsub(/\n| /, ""))
  bulk_insert_data << GameDetail.new(game_code: 1291102, number: 1, properties: '{
    "score":"0-0",
    "judge":"2-1",
    "progress":"灯台-灯台",
    "memo":"釧路は旭川より灯台完成が早かった。"
  }'.gsub(/\n| /, ""))
end
GameDetail.import bulk_insert_data
