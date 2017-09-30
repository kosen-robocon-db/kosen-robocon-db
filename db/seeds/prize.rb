bulk_insert_data = []

# ベスト４以上の成績
bulk_insert_data << Prize.new(kind: 1, name: "優勝")
bulk_insert_data << Prize.new(kind: 2, name: "準優勝")
bulk_insert_data << Prize.new(kind: 3, name: "ベスト４") # 入力便宜上用意
bulk_insert_data << Prize.new(kind: 4, name: "ベスト４") # 入力便宜上用意

# 主要賞
bulk_insert_data << Prize.new(kind: 11, name: "アイデア賞")
bulk_insert_data << Prize.new(kind: 12, name: "アイデア倒れ賞")
bulk_insert_data << Prize.new(kind: 13, name: "技術賞")
bulk_insert_data << Prize.new(kind: 14, name: "大賞")
bulk_insert_data << Prize.new(kind: 15, name: "ベストデザイン賞")
bulk_insert_data << Prize.new(kind: 16, name: "芸術賞")
bulk_insert_data << Prize.new(kind: 17, name: "デザイン賞")

# チームの活躍または活躍が期待されるチームに与えられた賞
bulk_insert_data << Prize.new(kind: 21, name: "完全燃賞")
bulk_insert_data << Prize.new(kind: 22, name: "優秀賞")
bulk_insert_data << Prize.new(kind: 23, name: "パフォーマンス賞")

# その他の賞
bulk_insert_data << Prize.new(kind: 31, name: "応援団賞")
bulk_insert_data << Prize.new(kind: 32, name: "ベストビデオ賞")

# テーマを冠した賞
bulk_insert_data << Prize.new(kind: 41, name: "ふるさと自慢賞")
bulk_insert_data << Prize.new(kind: 42, name: "風林火山賞")
bulk_insert_data << Prize.new(kind: 43, name: "生命大進化賞")
bulk_insert_data << Prize.new(kind: 44, name: "ベストカップル賞")
bulk_insert_data << Prize.new(kind: 45, name: "激走賞")
bulk_insert_data << Prize.new(kind: 46, name: "ロボ・ボウル賞")
bulk_insert_data << Prize.new(kind: 47, name: "ベスト・ペット賞")
bulk_insert_data << Prize.new(kind: 48, name: "シャル・ウィ・ジャンプ賞")
bulk_insert_data << Prize.new(kind: 49, name: "出前迅速賞")

# 特別賞
bulk_insert_data << Prize.new(kind: 51, name: "特別賞")
bulk_insert_data << Prize.new(kind: 52, name: "省エネルギーセンター賞")
bulk_insert_data << Prize.new(kind: 53, name: "電気事業連合会賞")
bulk_insert_data << Prize.new(kind: 54, name: "NECグループ賞") # 地区大会

# 特別賞（電力会社以外）
bulk_insert_data << Prize.new(kind: 61, name: "特別賞（本田技研工業株式会社）")
bulk_insert_data << Prize.new(kind: 62, name: "特別賞（電気事業連合会）")
bulk_insert_data << Prize.new(kind: 63, name: "特別賞（マブチモーター株式会社）")
bulk_insert_data << Prize.new(kind: 64, name: "特別賞（ソリッドワークスジャパン株式会社）")
bulk_insert_data << Prize.new(kind: 65, name: "特別賞（株式会社安川電機）")
bulk_insert_data << Prize.new(kind: 66, name: "特別賞（東京エレクトロンＦＥ株式会社）")
bulk_insert_data << Prize.new(kind: 67, name: "特別賞（田中貴金属グル－プ）")
bulk_insert_data << Prize.new(kind: 68, name: "特別賞（ローム株式会社）")

# 特別賞（電力会社）
bulk_insert_data << Prize.new(kind: 71, name: "特別賞（北海道電力株式会社）")
bulk_insert_data << Prize.new(kind: 72, name: "特別賞（東北電力株式会社）")
bulk_insert_data << Prize.new(kind: 73, name: "特別賞（東京電力株式会社）")
bulk_insert_data << Prize.new(kind: 74, name: "特別賞（中部・北陸電力株式会社）")
bulk_insert_data << Prize.new(kind: 75, name: "特別賞（関西電力株式会社）")
bulk_insert_data << Prize.new(kind: 76, name: "特別賞（中国電力株式会社）")
bulk_insert_data << Prize.new(kind: 77, name: "特別賞（四国電力株式会社）")
bulk_insert_data << Prize.new(kind: 78, name: "特別賞（九州・沖縄電力株式会社）")

Prize.import bulk_insert_data
