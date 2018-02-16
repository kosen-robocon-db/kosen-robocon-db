module RobotsHelper
  # ノックアウト方式だけではない予選がある大会もあるのでこのcaseで分類する方式を採用
  def game_name(nth:, region:, round:, game:)
    round_name = RoundName.find_by(contest_nth: nth, region_code: region, round: round)
    a = "#{round_name.name}"
    if round_name.name != "決勝" then
      a += " 第#{game}試合"
    end
    a
  end
end
