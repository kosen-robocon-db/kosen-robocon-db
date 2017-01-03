
region = Region.create(name: "北海道")

Campus.create(region: region, name: "旭川工業高等専門学校",   abbreviation: "旭川")
Campus.create(region: region, name: "釧路工業高等専門学校",   abbreviation: "釧路")
Campus.create(region: region, name: "札幌市立高等専門学校",   abbreviation: "札幌")
Campus.create(region: region, name: "苫小牧工業高等専門学校", abbreviation: "苫小牧")
Campus.create(region: region, name: "函館工業高等専門学校",   abbreviation: "函館")

region = Region.create(name: "東北")

region = Region.create(name: "関東甲信越")

region = Region.create(name: "東海北陸")

region = Region.create(name: "近畿")

region = Region.create(name: "中国")

region = Region.create(name: "四国")

region = Region.create(name: "九州沖縄")

region = Region.create(name: "他")

Contest.create(nth:  1, year: 1988, name: "乾電池カー・スピードレース")
Contest.create(nth:  2, year: 1989, name: "オクトパスフットボール")
Contest.create(nth:  3, year: 1990, name: "ニュートロンスター")
Contest.create(nth:  4, year: 1991, name: "ホットタワー")
Contest.create(nth:  5, year: 1992, name: "ミステリーサークル")
Contest.create(nth:  6, year: 1993, name: "ステップダンス")
Contest.create(nth:  7, year: 1994, name: "スペースフライヤー")
Contest.create(nth:  8, year: 1995, name: "ドリームタワー")
Contest.create(nth:  9, year: 1996, name: "テクノカウボーイ")
Contest.create(nth: 10, year: 1997, name: "花開蝶来")
Contest.create(nth: 11, year: 1998, name: "生命上陸")
Contest.create(nth: 12, year: 1999, name: "Jump To The Future")
Contest.create(nth: 13, year: 2000, name: "ミレニアムメッセージ")
Contest.create(nth: 14, year: 2001, name: "Happy Birthday 39")
Contest.create(nth: 15, year: 2002, name: "プロジェクトBOX")
Contest.create(nth: 16, year: 2003, name: "鼎")
Contest.create(nth: 17, year: 2004, name: "マーズラッシュ")
Contest.create(nth: 18, year: 2005, name: "大運動会")
Contest.create(nth: 19, year: 2006, name: "ふるさと自慢特急便")
Contest.create(nth: 20, year: 2007, name: "風林火山 ロボット騎馬戦")
Contest.create(nth: 21, year: 2008, name: "ROBO－EVOLUTION 生命大進化")
Contest.create(nth: 22, year: 2009, name: "DANCIN' COUPLE")
Contest.create(nth: 23, year: 2010, name: "激走! ロボ力車")
Contest.create(nth: 24, year: 2011, name: "ロボ・ボウル")
Contest.create(nth: 25, year: 2012, name: "ベスト・ペット")
Contest.create(nth: 26, year: 2013, name: "Shall We Jump?")
Contest.create(nth: 27, year: 2014, name: "出前迅速")
Contest.create(nth: 28, year: 2015, name: "輪花繚乱")
Contest.create(nth: 29, year: 2016, name: "ロボット・ニューフロンティア")

Robot.create(contest: Contest.find_by(nth:  2), campus: Campus.find_by(abbreviation: "旭川"), name: "ビッグシューター", kana: "ビッグシューター")
Robot.create(contest: Contest.find_by(nth:  3), campus: Campus.find_by(abbreviation: "旭川"), name: "マジックカーペット", kana: "マジックカーペット")
Robot.create(contest: Contest.find_by(nth:  4), campus: Campus.find_by(abbreviation: "旭川"), name: "Fly Swatter", kana: "フライスワッター")
Robot.create(contest: Contest.find_by(nth:  4), campus: Campus.find_by(abbreviation: "旭川"), name: "セブンボンバー", kana: "セブンボンバー")
Robot.create(contest: Contest.find_by(nth:  5), campus: Campus.find_by(abbreviation: "旭川"), name: "春光台にそそり立つ", kana: "シュンコウダイニソソリタツ")
Robot.create(contest: Contest.find_by(nth:  5), campus: Campus.find_by(abbreviation: "旭川"), name: "ANCoT16", kana: "アンコットシックスティーン")
Robot.create(contest: Contest.find_by(nth:  6), campus: Campus.find_by(abbreviation: "旭川"), name: "かっとびチュー太", kana: "カットビチュータ")
Robot.create(contest: Contest.find_by(nth:  6), campus: Campus.find_by(abbreviation: "旭川"), name: "大雪山ジムカデ号", kana: "タイセツザンジムカデゴウ")
Robot.create(contest: Contest.find_by(nth:  7), campus: Campus.find_by(abbreviation: "旭川"), name: "アンモナイト", kana: "アンモナイト")
Robot.create(contest: Contest.find_by(nth:  7), campus: Campus.find_by(abbreviation: "旭川"), name: "大雪山ウスバキチョウ", kana: "オオユキヤマウスバキチョウ")
Robot.create(contest: Contest.find_by(nth:  8), campus: Campus.find_by(abbreviation: "旭川"), name: "ビューティフルシューター", kana: "ビューティフルシューター")
Robot.create(contest: Contest.find_by(nth:  8), campus: Campus.find_by(abbreviation: "旭川"), name: "コマクサ", kana: "コマクサ")
Robot.create(contest: Contest.find_by(nth:  9), campus: Campus.find_by(abbreviation: "旭川"), name: "らいとにんぐ", kana: "ライトニング")
Robot.create(contest: Contest.find_by(nth:  9), campus: Campus.find_by(abbreviation: "旭川"), name: "北乃麒麟", kana: "キタノキリン")
Robot.create(contest: Contest.find_by(nth: 10), campus: Campus.find_by(abbreviation: "旭川"), name: "SPEEDY WONDER", kana: "スピーディーワンダー")
Robot.create(contest: Contest.find_by(nth: 10), campus: Campus.find_by(abbreviation: "旭川"), name: "HAPPY1号", kana: "ハッピーイチゴウ")
Robot.create(contest: Contest.find_by(nth: 11), campus: Campus.find_by(abbreviation: "旭川"), name: "MACH-CHAN1号", kana: "マッハチャンイチゴウ")
Robot.create(contest: Contest.find_by(nth: 11), campus: Campus.find_by(abbreviation: "旭川"), name: "ジムカデJr.号", kana: "ジムカデジュニアゴウ")
Robot.create(contest: Contest.find_by(nth: 12), campus: Campus.find_by(abbreviation: "旭川"), name: "Blitz Schnell", kana: "ブリッツシュネル")
Robot.create(contest: Contest.find_by(nth: 12), campus: Campus.find_by(abbreviation: "旭川"), name: "Safety Slope", kana: "セイフティースロープ")
Robot.create(contest: Contest.find_by(nth: 13), campus: Campus.find_by(abbreviation: "旭川"), name: "大車輪", kana: "ダイシャリン")
Robot.create(contest: Contest.find_by(nth: 13), campus: Campus.find_by(abbreviation: "旭川"), name: "Be Shorten", kana: "ビーショーテン")
Robot.create(contest: Contest.find_by(nth: 14), campus: Campus.find_by(abbreviation: "旭川"), name: "BELL FLOWER", kana: "ベルフラワー")
Robot.create(contest: Contest.find_by(nth: 14), campus: Campus.find_by(abbreviation: "旭川"), name: "grasp", kana: "グラスプ")
Robot.create(contest: Contest.find_by(nth: 15), campus: Campus.find_by(abbreviation: "旭川"), name: "Master Plan", kana: "マスタープラン")
Robot.create(contest: Contest.find_by(nth: 15), campus: Campus.find_by(abbreviation: "旭川"), name: "the jail", kana: "ザジェイル")
Robot.create(contest: Contest.find_by(nth: 16), campus: Campus.find_by(abbreviation: "旭川"), name: "Untyred", kana: "アンタイヤド")
Robot.create(contest: Contest.find_by(nth: 16), campus: Campus.find_by(abbreviation: "旭川"), name: "Clock Ruler", kana: "クロックルーラー")
Robot.create(contest: Contest.find_by(nth: 17), campus: Campus.find_by(abbreviation: "旭川"), name: "Sleip", kana: "スレイプ")
Robot.create(contest: Contest.find_by(nth: 17), campus: Campus.find_by(abbreviation: "旭川"), name: "Cosmos", kana: "コスモス")
Robot.create(contest: Contest.find_by(nth: 18), campus: Campus.find_by(abbreviation: "旭川"), name: "パッション!!", kana: "パッション")
Robot.create(contest: Contest.find_by(nth: 18), campus: Campus.find_by(abbreviation: "旭川"), name: "concord", kana: "コンコード")
Robot.create(contest: Contest.find_by(nth: 19), campus: Campus.find_by(abbreviation: "旭川"), name: "セタ", kana: "セタ")
Robot.create(contest: Contest.find_by(nth: 19), campus: Campus.find_by(abbreviation: "旭川"), name: "初雪", kana: "ハツユキ")
Robot.create(contest: Contest.find_by(nth: 20), campus: Campus.find_by(abbreviation: "旭川"), name: "NOTEC", kana: "ノテック")
Robot.create(contest: Contest.find_by(nth: 20), campus: Campus.find_by(abbreviation: "旭川"), name: "ＧＬＡＤＩＯＬＵＳ", kana: "グラディオラス")
Robot.create(contest: Contest.find_by(nth: 21), campus: Campus.find_by(abbreviation: "旭川"), name: "KAMUI", kana: "カムイ")
Robot.create(contest: Contest.find_by(nth: 21), campus: Campus.find_by(abbreviation: "旭川"), name: "TRIVIOS", kana: "トリヴィオス")
Robot.create(contest: Contest.find_by(nth: 22), campus: Campus.find_by(abbreviation: "旭川"), name: "北の海から", kana: "キタノウミカラ")
Robot.create(contest: Contest.find_by(nth: 22), campus: Campus.find_by(abbreviation: "旭川"), name: "ＫＡＧＵＹＡ", kana: "カグヤ")
Robot.create(contest: Contest.find_by(nth: 23), campus: Campus.find_by(abbreviation: "旭川"), name: "7Walk", kana: "セブンウォーク")
Robot.create(contest: Contest.find_by(nth: 23), campus: Campus.find_by(abbreviation: "旭川"), name: "ｒｅｖｌｉｓ", kana: "レヴリス")
Robot.create(contest: Contest.find_by(nth: 24), campus: Campus.find_by(abbreviation: "旭川"), name: "ｓｉｄｅ　ＷＩＮｄｅｒ", kana: "サイドワインダー")
Robot.create(contest: Contest.find_by(nth: 24), campus: Campus.find_by(abbreviation: "旭川"), name: "ＸｉｇＸａｇ", kana: "ジグザグ")
Robot.create(contest: Contest.find_by(nth: 25), campus: Campus.find_by(abbreviation: "旭川"), name: "ぽちべろす", kana: "ポチベロス")
Robot.create(contest: Contest.find_by(nth: 25), campus: Campus.find_by(abbreviation: "旭川"), name: "旭", kana: "キュウビ")
Robot.create(contest: Contest.find_by(nth: 26), campus: Campus.find_by(abbreviation: "旭川"), name: "JANPY", kana: "ジャンピー")
Robot.create(contest: Contest.find_by(nth: 26), campus: Campus.find_by(abbreviation: "旭川"), name: "カメニカルズ", kana: "カメニカルズ")
Robot.create(contest: Contest.find_by(nth: 27), campus: Campus.find_by(abbreviation: "旭川"), name: "ベルーガ", kana: "ベルーガ")
Robot.create(contest: Contest.find_by(nth: 27), campus: Campus.find_by(abbreviation: "旭川"), name: "蒸龍", kana: "セイロン")
Robot.create(contest: Contest.find_by(nth: 28), campus: Campus.find_by(abbreviation: "旭川"), name: "Orthrows", kana: "オルトロス")
Robot.create(contest: Contest.find_by(nth: 28), campus: Campus.find_by(abbreviation: "旭川"), name: "―Umbrella―", kana: "アンブレラ")
Robot.create(contest: Contest.find_by(nth: 29), campus: Campus.find_by(abbreviation: "旭川"), name: "HYDRA", kana: "ヒュドラ", team: "A")
Robot.create(contest: Contest.find_by(nth: 29), campus: Campus.find_by(abbreviation: "旭川"), name: "sucfaro、sucforte", kana: "サクファロ　サクフォート", team: "B")
