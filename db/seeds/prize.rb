# テストデータ（全国大会のみ）
# ロボットコードに含まれるA/Bチームの情報が書き換えられたらこの情報も書き換える必要がある

# 旭川
# Campus.create(region_code: 1, code: 1010, name: "旭川工業高等専門学校", abbreviation: "旭川", latitude: 43.812361, longitude: 142.353665)
Prize.create(contest_nth:  6, region_code: 0, campus_code: 1010, robot_code: 106110102, prize_kind:  1) # 優勝
Prize.create(contest_nth: 11, region_code: 0, campus_code: 1010, robot_code: 111110101, prize_kind:  3) # ベスト4
Prize.create(contest_nth: 11, region_code: 0, campus_code: 1010, robot_code: 111110101, prize_kind: 14) # 大賞
Prize.create(contest_nth: 16, region_code: 0, campus_code: 1010, robot_code: 116110101, prize_kind:  1) # 優勝
Prize.create(contest_nth: 20, region_code: 0, campus_code: 1010, robot_code: 120110101, prize_kind: 62) # 特別賞（電気事業連合会）
Prize.create(contest_nth: 23, region_code: 0, campus_code: 1010, robot_code: 123110102, prize_kind:  3) # ベスト4
Prize.create(contest_nth: 25, region_code: 0, campus_code: 1010, robot_code: 125110102, prize_kind:  3) # ベスト4
Prize.create(contest_nth: 27, region_code: 0, campus_code: 1010, robot_code: 127110101, prize_kind:  2) # 準優勝

# 一関
# Campus.create(region_code: 2, code: 2080, name: "一関工業高等専門学校", abbreviation: "一関", latitude: 38.92378, longitude: 141.107268)
Prize.create(contest_nth:  1, region_code: 0, campus_code: 2080, robot_code: 101220801, prize_kind: 11) # アイデア賞
Prize.create(contest_nth:  4, region_code: 0, campus_code: 2080, robot_code: 104220801, prize_kind:  1) # 技術賞
Prize.create(contest_nth:  5, region_code: 0, campus_code: 2080, robot_code: 105220801, prize_kind:  1) # 優勝
Prize.create(contest_nth: 10, region_code: 0, campus_code: 2080, robot_code: 110220802, prize_kind:  2) # 準優勝
Prize.create(contest_nth: 17, region_code: 0, campus_code: 2080, robot_code: 117220801, prize_kind:  3) # ベスト４
Prize.create(contest_nth: 17, region_code: 0, campus_code: 2080, robot_code: 117220801, prize_kind: 11) # アイデア賞
Prize.create(contest_nth: 20, region_code: 0, campus_code: 2080, robot_code: 120220801, prize_kind: 11) # 風林火山賞
Prize.create(contest_nth: 22, region_code: 0, campus_code: 2080, robot_code: 122220802, prize_kind: 17) # デザイン賞
Prize.create(contest_nth: 24, region_code: 0, campus_code: 2080, robot_code: 124220802, prize_kind: 63) # 特別賞（マブチモーター株式会社）
Prize.create(contest_nth: 25, region_code: 0, campus_code: 2080, robot_code: 125220801, prize_kind:  1) # ベスト４

# サレジオ
# Campus.create(region_code: 3, code: 3210, name: "サレジオ工業高等専門学校", abbreviation: "サレジオ", latitude: 35.605284, longitude: 139.357938)
Prize.create(contest_nth:  3, region_code: 0, campus_code: 3210, robot_code: 103332101, prize_kind:  3) # ベスト４
Prize.create(contest_nth:  3, region_code: 0, campus_code: 3210, robot_code: 103332101, prize_kind: 13) # 技術賞
Prize.create(contest_nth: 14, region_code: 0, campus_code: 3210, robot_code: 114332102, prize_kind: 17) # デザイン賞
Prize.create(contest_nth: 15, region_code: 0, campus_code: 3210, robot_code: 115332101, prize_kind: 17) # デザイン賞
Prize.create(contest_nth: 15, region_code: 0, campus_code: 3210, robot_code: 115332101, prize_kind: 62) # 特別賞（電気事業連合会）
Prize.create(contest_nth: 20, region_code: 0, campus_code: 3210, robot_code: 120332102, prize_kind: 14) # 大賞
Prize.create(contest_nth: 20, region_code: 0, campus_code: 3210, robot_code: 120332102, prize_kind: 61) # 特別賞（本田技研工業株式会社）

# 木更津
# Campus.create(region_code: 3, code: 3230, name: "木更津工業高等専門学校", abbreviation: "木更津", latitude: 35.384422, longitude: 139.955556)
Prize.create(contest_nth: 29, region_code: 0, campus_code: 3230, robot_code: 129332302, prize_kind: 12) # アイデア倒れ賞


# 神戸市立
# Campus.create(region_code: 5, code: 5370, name: "神戸市立工業高等専門学校", abbreviation: "神戸", latitude: 34.679577, longitude: 135.067222)
Prize.create(contest_nth:  7, region_code: 0, campus_code: 5370, robot_code: 107553701, prize_kind:  3) # ベスト４
Prize.create(contest_nth:  8, region_code: 0, campus_code: 5370, robot_code: 108553701, prize_kind: 31) # 応援団賞

# 徳山
# Campus.create(region_code: 6, code: 6460, name: "徳山工業高等専門学校", abbreviation: "徳山", latitude: 34.052226, longitude: 131.846532)
Prize.create(contest_nth:  4, region_code: 0, campus_code: 6460, robot_code: 104664601, prize_kind:  2) # 準優勝
Prize.create(contest_nth:  5, region_code: 0, campus_code: 6460, robot_code: 105664601, prize_kind: 11) # アイデア賞
Prize.create(contest_nth:  7, region_code: 0, campus_code: 6460, robot_code: 107664601, prize_kind:  3) # ベスト４
Prize.create(contest_nth:  9, region_code: 0, campus_code: 6460, robot_code: 109664601, prize_kind:  1) # 優勝
Prize.create(contest_nth: 12, region_code: 0, campus_code: 6460, robot_code: 112664601, prize_kind: 14) # 大賞
Prize.create(contest_nth: 15, region_code: 0, campus_code: 6460, robot_code: 115664602, prize_kind: 11) # アイデア賞
Prize.create(contest_nth: 19, region_code: 0, campus_code: 6460, robot_code: 119664601, prize_kind: 13) # 技術賞
Prize.create(contest_nth: 19, region_code: 0, campus_code: 6460, robot_code: 119664601, prize_kind: 64) # 特別賞（ソリッドワークスジャパン株式会社）
Prize.create(contest_nth: 21, region_code: 0, campus_code: 6460, robot_code: 121664602, prize_kind:  3) # ベスト４
Prize.create(contest_nth: 26, region_code: 0, campus_code: 6460, robot_code: 126664601, prize_kind:  1) # 優勝
Prize.create(contest_nth: 28, region_code: 0, campus_code: 6460, robot_code: 128664601, prize_kind: 68) # 特別賞（ローム株式会社）

# 有明
# Campus.create(region_code: 8, code: 8590, name: "有明工業高等専門学校", abbreviation: "有明", latitude: 33.00373, longitude: 130.473949)
Prize.create(contest_nth:  2, region_code: 0, campus_code: 8590, robot_code: 102885901, prize_kind:  3) # ベスト４
Prize.create(contest_nth:  2, region_code: 0, campus_code: 8590, robot_code: 102885901, prize_kind: 13) # 技術賞
Prize.create(contest_nth:  3, region_code: 0, campus_code: 8590, robot_code: 103885901, prize_kind:  3) # ベスト４
Prize.create(contest_nth:  5, region_code: 0, campus_code: 8590, robot_code: 105885901, prize_kind: 11) # アイデア賞
Prize.create(contest_nth: 24, region_code: 0, campus_code: 8590, robot_code: 124885901, prize_kind: 65) # 特別賞（株式会社安川電機）
Prize.create(contest_nth: 25, region_code: 0, campus_code: 8590, robot_code: 125885902, prize_kind: 65) # 特別賞（株式会社安川電機）
