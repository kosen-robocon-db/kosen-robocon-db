# Campus および Region が先に import されていること
bulk_insert_data = []
bulk_insert_data << CampusHistory.new(campus_code: Campus.find_by(abbreviation: "仙台広瀬").code, begin: 3, end: 21, name: "仙台電波工業高等専門学校", abbreviation: "仙台電波", region_code: Region.find_by(name: "東北").code)
bulk_insert_data << CampusHistory.new(campus_code: Campus.find_by(abbreviation: "仙台名取").code, begin: 3, end: 21, name: "宮城工業高等専門学校", abbreviation: "宮城", region_code: Region.find_by(name: "東北").code)
bulk_insert_data << CampusHistory.new(campus_code: Campus.find_by(abbreviation: "産技荒川").code, begin: 2, end: 18, name: "東京都立航空工業高等専門学校", abbreviation: "航空", region_code: Region.find_by(name: "関東甲信越").code)
bulk_insert_data << CampusHistory.new(campus_code: Campus.find_by(abbreviation: "産技品川").code, begin: 3, end: 18, name: "東京都立工業高等専門学校", abbreviation: "都立", region_code: Region.find_by(name: "関東甲信越").code)
bulk_insert_data << CampusHistory.new(campus_code: Campus.find_by(abbreviation: "サレジオ").code, begin: 3, end: 17, name: "育英工業高等専門学校", abbreviation: "育英", region_code: Region.find_by(name: "関東甲信越").code)
bulk_insert_data << CampusHistory.new(campus_code: Campus.find_by(abbreviation: "富山射水").code, begin: 3, end: 21, name: "富山商船高等専門学校", abbreviation: "富山商船", region_code: Region.find_by(name: "東海北陸").code)
bulk_insert_data << CampusHistory.new(campus_code: Campus.find_by(abbreviation: "富山本郷").code, begin: 1, end: 21, name: "富山工業高等専門学校", abbreviation: "富山", region_code: Region.find_by(name: "東海北陸").code)
bulk_insert_data << CampusHistory.new(campus_code: Campus.find_by(abbreviation: "国際").code, begin: 1, end: 30, name: "金沢工業高等専門学校", abbreviation: "金沢", region_code: Region.find_by(name: "東海北陸").code)
bulk_insert_data << CampusHistory.new(campus_code: Campus.find_by(abbreviation: "大阪府大").code, begin: 3, end: 23, name: "大阪府立工業高等専門学校", abbreviation: "大阪府立", region_code: Region.find_by(name: "近畿").code)
bulk_insert_data << CampusHistory.new(campus_code: Campus.find_by(abbreviation: "近大").code, begin: 3, end:  7, name: "熊野工業高等専門学校", abbreviation: "熊野", region_code: Region.find_by(name: "東海北陸").code)
bulk_insert_data << CampusHistory.new(campus_code: Campus.find_by(abbreviation: "近大").code, begin: 8, end: 12, name: "熊野工業高等専門学校", abbreviation: "熊野", region_code: Region.find_by(name: "近畿").code)
bulk_insert_data << CampusHistory.new(campus_code: Campus.find_by(abbreviation: "香川高松").code, begin: 3, end: 21, name: "高松工業高等専門学校", abbreviation: "高松", region_code: Region.find_by(name: "四国").code)
bulk_insert_data << CampusHistory.new(campus_code: Campus.find_by(abbreviation: "香川詫間").code, begin: 2, end: 21, name: "詫間電波工業高等専門学校", abbreviation: "詫間電波", region_code: Region.find_by(name: "四国").code)
bulk_insert_data << CampusHistory.new(campus_code: Campus.find_by(abbreviation: "熊本熊本").code, begin: 3, end: 21, name: "熊本電波工業高等専門学校", abbreviation: "熊本電波", region_code: Region.find_by(name: "九州沖縄").code)
bulk_insert_data << CampusHistory.new(campus_code: Campus.find_by(abbreviation: "熊本八代").code, begin: 3, end: 21, name: "八代工業高等専門学校", abbreviation: "八代", region_code: Region.find_by(name: "九州沖縄").code)
CampusHistory.import bulk_insert_data
