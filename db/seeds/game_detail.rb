# see game.rb and http://www.nhk.or.jp/robocon/rbcn2016/result.html
# Game.create(code: 1291101, contest_nth: 29, region_code: 1, round: 1, game: 1, left_robot_code: 129110401, right_robot_code: 129110502, winner_robot_code: 129110502)
# Game.create(code: 1291102, contest_nth: 29, region_code: 1, round: 1, game: 2, left_robot_code: 129110102, right_robot_code: 129110201, winner_robot_code: 129110201)
# Game.create(code: 1291103, contest_nth: 29, region_code: 1, round: 1, game: 3, left_robot_code: 129110402, right_robot_code: 129110101, winner_robot_code: 129110101)
# Game.create(code: 1291104, contest_nth: 29, region_code: 1, round: 1, game: 4, left_robot_code: 129110202, right_robot_code: 129110501, winner_robot_code: 129110501)
# Game.create(code: 1291201, contest_nth: 29, region_code: 1, round: 2, game: 1, left_robot_code: 129110502, right_robot_code: 129110201, winner_robot_code: 129110201)
# Game.create(code: 1291202, contest_nth: 29, region_code: 1, round: 2, game: 2, left_robot_code: 129110101, right_robot_code: 129110501, winner_robot_code: 129110101)
# Game.create(code: 1291301, contest_nth: 29, region_code: 1, round: 3, game: 1, left_robot_code: 129110201, right_robot_code: 129110101, winner_robot_code: 129110101)

GameDetail.create(game_code: 1291101, properties: {
  "score":"0-0",
  "judge":"3-0",
})
GameDetail.create(game_code: 1291102, properties: {
  "score":"0-0",
  "judge":"2-1",
  "memo":"釧路は旭川より灯台完成が早かった。"
})
