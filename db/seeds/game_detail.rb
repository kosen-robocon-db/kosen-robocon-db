# see game.rb and http://www.nhk.or.jp/robocon/rbcn2016/result.html
# Game.create(code: 1291101, contest_nth: 29, region_code: 1, round: 1, game: 1, left_robot_code: 129110401, right_robot_code: 129110502, winner_robot_code: 129110502)
# Game.create(code: 1291102, contest_nth: 29, region_code: 1, round: 1, game: 2, left_robot_code: 129110102, right_robot_code: 129110201, winner_robot_code: 129110201)
# Game.create(code: 1291103, contest_nth: 29, region_code: 1, round: 1, game: 3, left_robot_code: 129110402, right_robot_code: 129110101, winner_robot_code: 129110101)
# Game.create(code: 1291104, contest_nth: 29, region_code: 1, round: 1, game: 4, left_robot_code: 129110202, right_robot_code: 129110501, winner_robot_code: 129110501)
# Game.create(code: 1291201, contest_nth: 29, region_code: 1, round: 2, game: 1, left_robot_code: 129110502, right_robot_code: 129110201, winner_robot_code: 129110201)
# Game.create(code: 1291202, contest_nth: 29, region_code: 1, round: 2, game: 2, left_robot_code: 129110101, right_robot_code: 129110501, winner_robot_code: 129110101)
# Game.create(code: 1291301, contest_nth: 29, region_code: 1, round: 3, game: 1, left_robot_code: 129110201, right_robot_code: 129110101, winner_robot_code: 129110101)

GameDetail.create(game_code: 1291101, properties: {
  "スコア":"0-0",
  "score":"0-0",
  "審査員判定":"3-0",
  "judges decision":"3-0",
  "勝者達成課題":"灯台",
  "winner progress":"灯台",
  "敗者達成課題":"なし",
  "loser progress":"なし"
})
GameDetail.create(game_code: 1291102, properties: {
  "スコア":"0-0",
  "score":"0-0",
  "審査員判定":"2-1",
  "judges decision":"2-1",
  "勝者達成課題":"灯台",
  "winner progress":"灯台",
  "敗者達成課題":"灯台",
  "loser progress":"灯台",
  "memo":"釧路は灯台完成が早かった。"
})
