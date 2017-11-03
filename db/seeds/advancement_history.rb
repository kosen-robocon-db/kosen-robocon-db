# ロボットコードに含まれるA/Bチームの情報が書き換えられたらこの情報も書き換える必要がある
require "csv"
CSV_FILE_PATH = "db/seeds/csv/advancement_histories.csv"
bulk_insert_data = []
if FileTest.exist?(CSV_FILE_PATH) then
  csv = CSV.read(CSV_FILE_PATH, headers: true)
  csv.each do |row|
    bulk_insert_data << AdvancementHistory.new(
      contest_nth:      row[0],
      region_code:      row[1],
      campus_code:      row[2],
      robot_code:       row[3],
      advancement_case: row[4],
      decline:          row[5],
      memo:             row[6]
    )
  end
else
  # 神戸高専
  # 乳母車
  bulk_insert_data << AdvancementHistory.new(
    contest_nth: 8, region_code: 5, campus_code: 5370, robot_code: 107553701,
    advancement_case: 1, decline: false, memo: ""
  )

  # BRUNHILDE
  bulk_insert_data << AdvancementHistory.new(
    contest_nth: 8, region_code: 5, campus_code: 5370, robot_code: 108553701,
    advancement_case: 2, decline: false, memo: ""
  )

  # 白龍
  bulk_insert_data << AdvancementHistory.new(
    contest_nth: 8, region_code: 5, campus_code: 5370, robot_code: 109553701,
    advancement_case: 2, decline: false, memo: ""
  )

  # ちゃれんじろう
  bulk_insert_data << AdvancementHistory.new(
    contest_nth: 8, region_code: 5, campus_code: 5370, robot_code: 112553701,
    advancement_case: 1, decline: false, memo: ""
  )

  # 栗太郎
  bulk_insert_data << AdvancementHistory.new(
    contest_nth: 8, region_code: 5, campus_code: 5370, robot_code: 115553701,
    advancement_case: 1, decline: false, memo: ""
  )

  # 撃ま栗
  bulk_insert_data << AdvancementHistory.new(
    contest_nth: 8, region_code: 5, campus_code: 5370, robot_code: 116553702,
    advancement_case: 2, decline: false, memo: ""
  )

  # 甲速［ｍ／ｓ］
  bulk_insert_data << AdvancementHistory.new(
    contest_nth: 8, region_code: 5, campus_code: 5370, robot_code: 127553701,
    advancement_case: 1, decline: false, memo: ""
  )

  # さるかにんぼう
  bulk_insert_data << AdvancementHistory.new(
    contest_nth: 8, region_code: 5, campus_code: 5370, robot_code: 130553701,
    advancement_case: 2, decline: false, memo: ""
  )
end
AdvancementHistory.import bulk_insert_data
