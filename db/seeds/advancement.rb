bulk_insert_data = []

# 全国進出ケース
bulk_insert_data << Advancement.new(case: 1, case_name: "優勝",
  description: "地区大会で優勝したロボットまたはチーム")
bulk_insert_data << Advancement.new(case: 2, case_name: "審査員推薦",
  description: "地区大会で審査員に推薦されたロボットまたはチーム")
bulk_insert_data << Advancement.new(case: 3, case_name: "競技委員会推薦",
  description: "全地区大会の中から競技委員会によって推薦されたロボットまたはチーム")
bulk_insert_data << Advancement.new(case: 4, case_name: "辞退由来の繰り上がり推薦",
  description: "他チーム辞退により繰り上がりで推薦されたロボットまたはチーム")
  # It's a rare case.

Advancement.import bulk_insert_data
