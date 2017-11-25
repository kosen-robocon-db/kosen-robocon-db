require "csv"
csv_file_path = "db/seeds/csv/robots.csv"
bulk_insert_data = []
if FileTest.exist?(csv_file_path) then
  csv = CSV.read(csv_file_path, headers: true)
  csv.each do |row|
    bulk_insert_data << Robot.new(
      code:        row[0],
      contest_nth: row[1],
      campus_code: row[2],
      team:        row[3],
      name:        row[4],
      kana:        row[5]
    )
  end
else
  bulk_insert_data << Robot.new(code: 102110100, contest_nth:  2, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "ビッグシューター", kana: "ビッグシューター")
  bulk_insert_data << Robot.new(code: 103110100, contest_nth:  3, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "マジックカーペット", kana: "マジックカーペット")
  bulk_insert_data << Robot.new(code: 104110101, contest_nth:  4, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "Fly Swatter", kana: "フライスワッター")
  bulk_insert_data << Robot.new(code: 104110102, contest_nth:  4, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "セブンボンバー", kana: "セブンボンバー")
  bulk_insert_data << Robot.new(code: 105110101, contest_nth:  5, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "春光台にそそり立つ", kana: "シュンコウダイニソソリタツ")
  bulk_insert_data << Robot.new(code: 105110102, contest_nth:  5, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "ANCoT16", kana: "アンコットシックスティーン")
  bulk_insert_data << Robot.new(code: 106110101, contest_nth:  6, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "かっとびチュー太", kana: "カットビチュータ", team: "B")
  bulk_insert_data << Robot.new(code: 106110102, contest_nth:  6, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "大雪山ジムカデ号", kana: "タイセツザンジムカデゴウ", team: "A")
  bulk_insert_data << Robot.new(code: 107110101, contest_nth:  7, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "アンモナイト", kana: "アンモナイト")
  bulk_insert_data << Robot.new(code: 107110102, contest_nth:  7, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "大雪山ウスバキチョウ", kana: "オオユキヤマウスバキチョウ")
  bulk_insert_data << Robot.new(code: 108110101, contest_nth:  8, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "ビューティフルシューター", kana: "ビューティフルシューター")
  bulk_insert_data << Robot.new(code: 108110102, contest_nth:  8, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "コマクサ", kana: "コマクサ")
  bulk_insert_data << Robot.new(code: 109110101, contest_nth:  9, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "らいとにんぐ", kana: "ライトニング")
  bulk_insert_data << Robot.new(code: 109110102, contest_nth:  9, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "北乃麒麟", kana: "キタノキリン")
  bulk_insert_data << Robot.new(code: 110110101, contest_nth: 10, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "SPEEDY WONDER", kana: "スピーディーワンダー")
  bulk_insert_data << Robot.new(code: 110110102, contest_nth: 10, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "HAPPY1号", kana: "ハッピーイチゴウ")
  bulk_insert_data << Robot.new(code: 111110101, contest_nth: 11, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "MACH-CHAN1号", kana: "マッハチャンイチゴウ")
  bulk_insert_data << Robot.new(code: 111110102, contest_nth: 11, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "ジムカデJr.号", kana: "ジムカデジュニアゴウ")
  bulk_insert_data << Robot.new(code: 112110101, contest_nth: 12, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "Blitz Schnell", kana: "ブリッツシュネル")
  bulk_insert_data << Robot.new(code: 112110102, contest_nth: 12, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "Safety Slope", kana: "セイフティースロープ")
  bulk_insert_data << Robot.new(code: 113110101, contest_nth: 13, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "大車輪", kana: "ダイシャリン")
  bulk_insert_data << Robot.new(code: 113110102, contest_nth: 13, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "Be Shorten", kana: "ビーショーテン")
  bulk_insert_data << Robot.new(code: 114110101, contest_nth: 14, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "BELL FLOWER", kana: "ベルフラワー")
  bulk_insert_data << Robot.new(code: 114110102, contest_nth: 14, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "grasp", kana: "グラスプ")
  bulk_insert_data << Robot.new(code: 115110101, contest_nth: 15, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "Master Plan", kana: "マスタープラン")
  bulk_insert_data << Robot.new(code: 115110102, contest_nth: 15, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "the jail", kana: "ザジェイル")
  bulk_insert_data << Robot.new(code: 116110101, contest_nth: 16, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "Untyred", kana: "アンタイヤド", team: "A")
  bulk_insert_data << Robot.new(code: 116110102, contest_nth: 16, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "Clock Ruler", kana: "クロックルーラー", team: "B")
  bulk_insert_data << Robot.new(code: 117110101, contest_nth: 17, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "Sleip", kana: "スレイプ")
  bulk_insert_data << Robot.new(code: 117110102, contest_nth: 17, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "Cosmos", kana: "コスモス")
  bulk_insert_data << Robot.new(code: 118110101, contest_nth: 18, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "パッション!!", kana: "パッション")
  bulk_insert_data << Robot.new(code: 118110102, contest_nth: 18, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "concord", kana: "コンコード")
  bulk_insert_data << Robot.new(code: 119110101, contest_nth: 19, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "セタ", kana: "セタ")
  bulk_insert_data << Robot.new(code: 119110102, contest_nth: 19, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "初雪", kana: "ハツユキ")
  bulk_insert_data << Robot.new(code: 120110101, contest_nth: 20, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "NOTEC", kana: "ノテック")
  bulk_insert_data << Robot.new(code: 120110102, contest_nth: 20, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "ＧＬＡＤＩＯＬＵＳ", kana: "グラディオラス")
  bulk_insert_data << Robot.new(code: 121110101, contest_nth: 21, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "KAMUI", kana: "カムイ")
  bulk_insert_data << Robot.new(code: 121110102, contest_nth: 21, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "TRIVIOS", kana: "トリヴィオス")
  bulk_insert_data << Robot.new(code: 122110101, contest_nth: 22, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "北の海から", kana: "キタノウミカラ")
  bulk_insert_data << Robot.new(code: 122110102, contest_nth: 22, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "ＫＡＧＵＹＡ", kana: "カグヤ")
  bulk_insert_data << Robot.new(code: 123110101, contest_nth: 23, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "7Walk", kana: "セブンウォーク")
  bulk_insert_data << Robot.new(code: 123110102, contest_nth: 23, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "ｒｅｖｌｉｓ", kana: "レヴリス")
  bulk_insert_data << Robot.new(code: 124110101, contest_nth: 24, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "ｓｉｄｅ　ＷＩＮｄｅｒ", kana: "サイドワインダー")
  bulk_insert_data << Robot.new(code: 124110102, contest_nth: 24, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "ＸｉｇＸａｇ", kana: "ジグザグ")
  bulk_insert_data << Robot.new(code: 125110101, contest_nth: 25, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "ぽちべろす", kana: "ポチベロス")
  bulk_insert_data << Robot.new(code: 125110102, contest_nth: 25, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "旭", kana: "キュウビ")
  bulk_insert_data << Robot.new(code: 126110101, contest_nth: 26, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "JANPY", kana: "ジャンピー")
  bulk_insert_data << Robot.new(code: 126110102, contest_nth: 26, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "カメニカルズ", kana: "カメニカルズ")
  bulk_insert_data << Robot.new(code: 127110101, contest_nth: 27, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "ベルーガ", kana: "ベルーガ")
  bulk_insert_data << Robot.new(code: 127110102, contest_nth: 27, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "蒸龍", kana: "セイロン")
  bulk_insert_data << Robot.new(code: 128110101, contest_nth: 28, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "Orthrows", kana: "オルトロス")
  bulk_insert_data << Robot.new(code: 128110102, contest_nth: 28, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "―Umbrella―", kana: "アンブレラ")
  bulk_insert_data << Robot.new(code: 129110101, contest_nth: 29, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "HYDRA", kana: "ヒュドラ", team: "A")
  bulk_insert_data << Robot.new(code: 129110102, contest_nth: 29, campus_code: Campus.find_by(abbreviation: "旭川").code, name: "sucfaro、sucforte", kana: "サクファロ　サクフォート", team: "B")
end
Robot.import bulk_insert_data
