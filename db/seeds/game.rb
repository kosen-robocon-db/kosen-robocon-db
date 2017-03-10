require "csv"
GAME_CSV_FILE_PATH="db/game.csv"
if FileTest.exist?(GAME_CSV_FILE_PATH) then
  csv = CSV.read(GAME_CSV_FILE_PATH)
  csv.each do |row|
    contest = Contest.find_by(code: row[0]) # contest_nth : 大会回
    region = Region.find_by(code: row[1]) # region_code : 地区コード（0は全国）
    round = row[2] # 何等かのチェックが必要？ # round : 回戦、game参照
    game = row[3] # 何等かのチェックが必要？ # game : 試合、1回戦(round)第1試合(game)
    team_left = Robot.find_by(code: row[4]) # team_left : 対戦した一方のチーム
    team_right = Robot.find_by(code: row[5]) # team_right : 対戦したもう一方のチーム
    winner_team = Robot.find_by(code: row[6]) # winner_team : 勝ったチーム
    if contest && region && team_left && team_right && winner_team then
      code = "1" + ("%02d" % contest.nth) + region.code.to_s + round.to_s + ("%02d" % game) # code : 試合コード
      Game.create(
        code: code.to_i,
        contest_nth: row[0],
        region_code: row[1],
        round: row[2],
        game: row[3],
        team_left: row[4],
        team_right: row[5],
        winner_team: row[6]
      )
    end
  end
else
  # http://www.nhk.or.jp/robocon/rbcn2016/result.html
  Game.create(code: 1291101, contest_nth: 29, region_code: 1, round: 1, game: 1, team_left: 129110401, team_right: 129110502, winner_team: 129110502)
  Game.create(code: 1291102, contest_nth: 29, region_code: 1, round: 1, game: 2, team_left: 129110102, team_right: 129110201, winner_team: 129110201)
  Game.create(code: 1291103, contest_nth: 29, region_code: 1, round: 1, game: 3, team_left: 129110402, team_right: 129110101, winner_team: 129110101)
  Game.create(code: 1291104, contest_nth: 29, region_code: 1, round: 1, game: 4, team_left: 129110202, team_right: 129110501, winner_team: 129110501)
  Game.create(code: 1291201, contest_nth: 29, region_code: 1, round: 2, game: 1, team_left: 129110502, team_right: 129110201, winner_team: 129110201)
  Game.create(code: 1291202, contest_nth: 29, region_code: 1, round: 2, game: 2, team_left: 129110101, team_right: 129110501, winner_team: 129110101)
  Game.create(code: 1291301, contest_nth: 29, region_code: 1, round: 3, game: 1, team_left: 129110201, team_right: 129110101, winner_team: 129110101)
end
