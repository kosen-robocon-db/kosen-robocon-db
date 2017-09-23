bulk_insert_data = []

bulk_insert_data << Region.new(code: 0, name: "全国")
bulk_insert_data << Region.new(code: 1, name: "北海道")
bulk_insert_data << Region.new(code: 2, name: "東北")
bulk_insert_data << Region.new(code: 3, name: "関東甲信越")
bulk_insert_data << Region.new(code: 4, name: "東海北陸")
bulk_insert_data << Region.new(code: 5, name: "近畿")
bulk_insert_data << Region.new(code: 6, name: "中国")
bulk_insert_data << Region.new(code: 7, name: "四国")
bulk_insert_data << Region.new(code: 8, name: "九州沖縄")
bulk_insert_data << Region.new(code: 9, name: "他")

Region.import bulk_insert_data
