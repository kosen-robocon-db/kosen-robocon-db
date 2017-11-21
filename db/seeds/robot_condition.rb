require "csv"
csv_file_path = "db/seeds/csv/robot_conditions.csv"
bulk_insert_data = []
if FileTest.exist?(csv_file_path) then
  codes = {}
  csv = CSV.read(csv_file_path, headers: true)
  csv.each do |row|
    robot = Robot.find_by(code: row[0]) # 全チームのAB区別が判明次第無くす
    if robot then
      bulk_insert_data << RobotCondition.new(
        robot_code: robot.code,
        fully_operational: row[1],
        restoration: row[2],
        memo: row[3]
      )
    end
  end
else
  # 徳山
#  bulk_insert_data << RobotCondition.new(robot_code: 103664601, fully_operational: true,  restoration: false) # ゴロゴロスッテン号 実際のデータはこちら
  bulk_insert_data << RobotCondition.new(robot_code: 103664601, fully_operational: true,  restoration: true) # ゴロゴロスッテン号 テスト用
  bulk_insert_data << RobotCondition.new(robot_code: 104664601, fully_operational: true,  restoration: false) # 白猫号
  bulk_insert_data << RobotCondition.new(robot_code: 109664601, fully_operational: true,  restoration: false) # 午前10時
  bulk_insert_data << RobotCondition.new(robot_code: 112664601, fully_operational: true,  restoration: false) # Fly Do ポテット S
  bulk_insert_data << RobotCondition.new(robot_code: 113664602, fully_operational: false, restoration: false) # Ring you
  bulk_insert_data << RobotCondition.new(robot_code: 115664602, fully_operational: false, restoration: false) # Side Bird Phoenix
  bulk_insert_data << RobotCondition.new(robot_code: 116664602, fully_operational: true,  restoration: false) # Ｓｅｉｔｅ　Ｖｏｇｅｌ　Ｄｒｅｉ
  bulk_insert_data << RobotCondition.new(robot_code: 117664602, fully_operational: false, restoration: false) # アノマロカリス
  bulk_insert_data << RobotCondition.new(robot_code: 119664601, fully_operational: false, restoration: false) # パンダ倶楽部
  bulk_insert_data << RobotCondition.new(robot_code: 120664602, fully_operational: false, restoration: false) # 五時エ門
  bulk_insert_data << RobotCondition.new(robot_code: 121664602, fully_operational: true,  restoration: false) # ツヨシ猿回し
  bulk_insert_data << RobotCondition.new(robot_code: 122664602, fully_operational: false, restoration: false) # はちみつが好き
  bulk_insert_data << RobotCondition.new(robot_code: 125664601, fully_operational: true,  restoration: false) # メカレオン倶楽部
  bulk_insert_data << RobotCondition.new(robot_code: 126664601, fully_operational: true,  restoration: false, memo: "当時の飴はメンバーが美味しく頂きました。") # 色とりドリィ
  bulk_insert_data << RobotCondition.new(robot_code: 128664601, fully_operational: true,  restoration: false) # 捲土重来
end
RobotCondition.import bulk_insert_data
