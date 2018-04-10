module RobotsHelper
  # ノックアウト方式だけではない予選がある大会もあるのでこのcaseで分類する方式を採用
  def game_name(hash:)
    round_name =
      RoundName.find_by(
        contest_nth: game["contest_nth"],
        region_code: game["region_code"],
        round: game["round"]
      ) ||
      RoundName.new(
        name: "未定義"
      )
    a = "#{round_name.name}"
    if round_name.name != "決勝" then
      a += " 第#{game["game"]}試合"
    end
    a
  end
end
