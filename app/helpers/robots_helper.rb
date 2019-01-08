module RobotsHelper
  # ノックアウト方式だけではない予選がある大会もあるのでこのcaseで分類する方式を採用
  def game_name(hash:)
    round_name =
      RoundName.find_by(
        contest_nth: hash["contest_nth"],
        region_code: hash["region_code"],
        round: hash["round"]
      ) ||
      RoundName.new(
        name: "未定義"
      )
    
    # 回戦
    a = "#{round_name.name}"

    # リーグ
    case hash["contest_nth"].to_i
    when 31
      case hash["region_code"].to_i
      when 1..8 # 第31回は地区のみリーグ戦実施
        case round_name.name
        when "予選"
          case hash["league"].to_i
          when 0
            a += "リーグ不明"
          when 1..5
            a += "リーグ" + ("A".ord + hash["league"].to_i - 1).chr
          else
            a += "リーグ異常値"
          end
        end
      end
    end

    # 試合
    if round_name.name != "決勝" then
      a += " 第#{hash["game"]}試合"
    end
    a
  end
end
