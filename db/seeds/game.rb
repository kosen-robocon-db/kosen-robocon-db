require "csv"
csv_file_path = "db/seeds/csv/games.csv"
bulk_insert_data = []
if FileTest.exist?(csv_file_path) then
  csv = CSV.read(csv_file_path, headers: true)
  csv.each do |row|
    bulk_insert_data << Game.new(
      code:              row[0],
      contest_nth:       row[1],
      region_code:       row[2],
      round:             row[3],
      game:              row[4],
      left_robot_code:   row[5],
      right_robot_code:  row[6],
      winner_robot_code: row[7]
    )
  end
else
  # http://www.nhk.or.jp/robocon/rbcn2016/result.html
  bulk_insert_data << Game.new(code: 1291101, contest_nth: 29, region_code: 1, round: 1, game: 1, left_robot_code: 129110401, right_robot_code: 129110502, winner_robot_code: 129110502)
  bulk_insert_data << Game.new(code: 1291102, contest_nth: 29, region_code: 1, round: 1, game: 2, left_robot_code: 129110102, right_robot_code: 129110201, winner_robot_code: 129110201)
  bulk_insert_data << Game.new(code: 1291103, contest_nth: 29, region_code: 1, round: 1, game: 3, left_robot_code: 129110402, right_robot_code: 129110101, winner_robot_code: 129110101)
  bulk_insert_data << Game.new(code: 1291104, contest_nth: 29, region_code: 1, round: 1, game: 4, left_robot_code: 129110202, right_robot_code: 129110501, winner_robot_code: 129110501)
  bulk_insert_data << Game.new(code: 1291201, contest_nth: 29, region_code: 1, round: 2, game: 1, left_robot_code: 129110502, right_robot_code: 129110201, winner_robot_code: 129110201)
  bulk_insert_data << Game.new(code: 1291202, contest_nth: 29, region_code: 1, round: 2, game: 2, left_robot_code: 129110101, right_robot_code: 129110501, winner_robot_code: 129110101)
  bulk_insert_data << Game.new(code: 1291301, contest_nth: 29, region_code: 1, round: 3, game: 1, left_robot_code: 129110201, right_robot_code: 129110101, winner_robot_code: 129110101)
end
Game.import bulk_insert_data, :validate => false # 検証なしにしないとエラーが出る
