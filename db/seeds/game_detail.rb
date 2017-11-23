require "csv"
csv_file_path = "db/seeds/csv/game_details.csv"
bulk_insert_data = []
if FileTest.exist?(csv_file_path) then
  csv = CSV.read(csv_file_path, headers: true)
  csv.each do |row|
    bulk_insert_data << GameDetail.new(
      game_code:  row[0],
      number:     row[1],
      properties: row[2]
    )
  end
else
  bulk_insert_data << GameDetail.new(game_code: 1291101, number: 1, properties: '{
    "height":"0-0",
    "jury_votes":"3-0",
    "progress":"灯台-なし"
  }'.gsub(/\n| /, ""))
  bulk_insert_data << GameDetail.new(game_code: 1291102, number: 1, properties: '{
    "height":"0-0",
    "jury_votes":"2-1",
    "progress":"灯台-灯台",
    "memo":"釧路は旭川より灯台完成が早かった。"
  }'.gsub(/\n| /, ""))
end
GameDetail.import bulk_insert_data
