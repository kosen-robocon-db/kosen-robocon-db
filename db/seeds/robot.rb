require "csv"
CSV_FILE_PATH="db/robot_name_entries.csv"
if FileTest.exist?(CSV_FILE_PATH) then
  codes = {}
  CSV.foreach(CSV_FILE_PATH) do |row|
    # '1'（1桁）＋大会コード （2桁）+ 地区コード（1桁） + キャンパスコード（4桁） + チーム（1桁）
    campus = Campus.find_by(code: row[2])
    if campus then # row[0]からrow[4]まで存在するかどうか確認すべきだが省略
      code = "1" + ("%02d" % row[0]) + campus.region_code.to_s + campus.code.to_s
      case row[5]
      when "A" then
        code += "1"
        team = "A"
      when "B" then
        code += "2"
        team = "B"
      else
        if codes.has_key?((code+"1").to_i) then
          code += "2"
        else
          code += "1"
          codes[code.to_i] = nil
        end
        team = ""
      end
      # puts code, row[0]), campus, row[3], row[4], team
      # 例外を処理する必要あり
      Robot.create(
        code: code.to_i,
        contest_nth: row[0],
        campus_code: campus.code,
        name: row[3],
        kana: row[4],
        team: team
      )
    end
  end
else
  Robot.create(code: 102110100, contest_nth:  2, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "ビッグシューター", kana: "ビッグシューター")
  Robot.create(code: 103110100, contest_nth:  3, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "マジックカーペット", kana: "マジックカーペット")
  Robot.create(code: 104110101, contest_nth:  4, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "Fly Swatter", kana: "フライスワッター")
  Robot.create(code: 104110102, contest_nth:  4, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "セブンボンバー", kana: "セブンボンバー")
  Robot.create(code: 105110101, contest_nth:  5, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "春光台にそそり立つ", kana: "シュンコウダイニソソリタツ")
  Robot.create(code: 105110102, contest_nth:  5, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "ANCoT16", kana: "アンコットシックスティーン")
  Robot.create(code: 106110101, contest_nth:  6, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "かっとびチュー太", kana: "カットビチュータ", team: "B")
  Robot.create(code: 106110102, contest_nth:  6, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "大雪山ジムカデ号", kana: "タイセツザンジムカデゴウ", team: "A")
  Robot.create(code: 107110101, contest_nth:  7, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "アンモナイト", kana: "アンモナイト")
  Robot.create(code: 107110102, contest_nth:  7, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "大雪山ウスバキチョウ", kana: "オオユキヤマウスバキチョウ")
  Robot.create(code: 108110101, contest_nth:  8, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "ビューティフルシューター", kana: "ビューティフルシューター")
  Robot.create(code: 108110102, contest_nth:  8, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "コマクサ", kana: "コマクサ")
  Robot.create(code: 109110101, contest_nth:  9, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "らいとにんぐ", kana: "ライトニング")
  Robot.create(code: 109110102, contest_nth:  9, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "北乃麒麟", kana: "キタノキリン")
  Robot.create(code: 110110101, contest_nth: 10, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "SPEEDY WONDER", kana: "スピーディーワンダー")
  Robot.create(code: 110110102, contest_nth: 10, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "HAPPY1号", kana: "ハッピーイチゴウ")
  Robot.create(code: 111110101, contest_nth: 11, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "MACH-CHAN1号", kana: "マッハチャンイチゴウ")
  Robot.create(code: 111110102, contest_nth: 11, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "ジムカデJr.号", kana: "ジムカデジュニアゴウ")
  Robot.create(code: 112110101, contest_nth: 12, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "Blitz Schnell", kana: "ブリッツシュネル")
  Robot.create(code: 112110102, contest_nth: 12, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "Safety Slope", kana: "セイフティースロープ")
  Robot.create(code: 113110101, contest_nth: 13, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "大車輪", kana: "ダイシャリン")
  Robot.create(code: 113110102, contest_nth: 13, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "Be Shorten", kana: "ビーショーテン")
  Robot.create(code: 114110101, contest_nth: 14, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "BELL FLOWER", kana: "ベルフラワー")
  Robot.create(code: 114110102, contest_nth: 14, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "grasp", kana: "グラスプ")
  Robot.create(code: 115110101, contest_nth: 15, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "Master Plan", kana: "マスタープラン")
  Robot.create(code: 115110102, contest_nth: 15, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "the jail", kana: "ザジェイル")
  Robot.create(code: 116110101, contest_nth: 16, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "Untyred", kana: "アンタイヤド", team: "A")
  Robot.create(code: 116110102, contest_nth: 16, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "Clock Ruler", kana: "クロックルーラー", team: "B")
  Robot.create(code: 117110101, contest_nth: 17, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "Sleip", kana: "スレイプ")
  Robot.create(code: 117110102, contest_nth: 17, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "Cosmos", kana: "コスモス")
  Robot.create(code: 118110101, contest_nth: 18, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "パッション!!", kana: "パッション")
  Robot.create(code: 118110102, contest_nth: 18, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "concord", kana: "コンコード")
  Robot.create(code: 119110101, contest_nth: 19, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "セタ", kana: "セタ")
  Robot.create(code: 119110102, contest_nth: 19, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "初雪", kana: "ハツユキ")
  Robot.create(code: 120110101, contest_nth: 20, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "NOTEC", kana: "ノテック")
  Robot.create(code: 120110102, contest_nth: 20, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "ＧＬＡＤＩＯＬＵＳ", kana: "グラディオラス")
  Robot.create(code: 121110101, contest_nth: 21, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "KAMUI", kana: "カムイ")
  Robot.create(code: 121110102, contest_nth: 21, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "TRIVIOS", kana: "トリヴィオス")
  Robot.create(code: 122110101, contest_nth: 22, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "北の海から", kana: "キタノウミカラ")
  Robot.create(code: 122110102, contest_nth: 22, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "ＫＡＧＵＹＡ", kana: "カグヤ")
  Robot.create(code: 123110101, contest_nth: 23, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "7Walk", kana: "セブンウォーク")
  Robot.create(code: 123110102, contest_nth: 23, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "ｒｅｖｌｉｓ", kana: "レヴリス")
  Robot.create(code: 124110101, contest_nth: 24, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "ｓｉｄｅ　ＷＩＮｄｅｒ", kana: "サイドワインダー")
  Robot.create(code: 124110102, contest_nth: 24, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "ＸｉｇＸａｇ", kana: "ジグザグ")
  Robot.create(code: 125110101, contest_nth: 25, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "ぽちべろす", kana: "ポチベロス")
  Robot.create(code: 125110102, contest_nth: 25, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "旭", kana: "キュウビ")
  Robot.create(code: 126110101, contest_nth: 26, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "JANPY", kana: "ジャンピー")
  Robot.create(code: 126110102, contest_nth: 26, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "カメニカルズ", kana: "カメニカルズ")
  Robot.create(code: 127110101, contest_nth: 27, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "ベルーガ", kana: "ベルーガ")
  Robot.create(code: 127110102, contest_nth: 27, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "蒸龍", kana: "セイロン")
  Robot.create(code: 128110101, contest_nth: 28, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "Orthrows", kana: "オルトロス")
  Robot.create(code: 128110102, contest_nth: 28, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "―Umbrella―", kana: "アンブレラ")
  Robot.create(code: 129110101, contest_nth: 29, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "HYDRA", kana: "ヒュドラ", team: "A")
  Robot.create(code: 129110102, contest_nth: 29, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "sucfaro、sucforte", kana: "サクファロ　サクフォート", team: "B")
end
