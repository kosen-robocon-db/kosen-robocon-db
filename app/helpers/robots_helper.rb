module RobotsHelper
  # ノックアウト方式だけではない予選がある大会もあるのでこのcaseで分類する方式を採用
  def game_name(nth:, region:,round:, game:)
    logger.debug(">>>> RobotsHelper#game_name #{nth}, #{region}, #{round}, #{game}")
    a = "#{round}回戦 第#{game}試合"
    case nth
    when 29 then # 第２９回大会
      case region
      when 8 then # 九州沖縄
        case round
        when 5 then # 準決勝
          a = "準決勝 第#{game}試合"
        when 6 then # 決勝
          a = "決勝戦"
        end
      end
    end
    a
  end
end
