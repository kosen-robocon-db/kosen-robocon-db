class RobotConditionsPDF < Prawn::Document
  def initialize(robot_conditions:)
    @conditions = robot_conditions
    super()
    font "vendor/fonts/ipaexm.ttf"
    text "高専ロボコンデータベース　ロボット保存状況"
    table rows do
      cells.padding = 8
      cells.borders = [:bottom,]
      cells.border_width = 0.5
      self.header = true
      self.row_colors = ['dddddd', 'ffffff']
      self.column_widths = [50,50,50,50,50,50,50,50,50,50]
    end
  end

  def rows
    a = [["ロボットコード", "学校名", "状況", "ロボット名", "読み仮名",
      "年", "回", "全国大会", "地区大会", "備考" ]]
    @conditions.map.with_index do |r, i|
      s = r.fully_operational ? "動態" : "静態"
      a << [r.robot_code, "", s, r.robot.name, r.robot.kana,
        r.robot.contest_nth + 1987, r.robot.contest_nth, "", "", "" ]
    end
    return a
  end
end
