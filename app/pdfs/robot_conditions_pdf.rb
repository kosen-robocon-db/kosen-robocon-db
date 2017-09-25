class RobotConditionsPDF < Prawn::Document
  def initialize(robot_conditions:)
    @conditions = robot_conditions
    super(page_size: 'A4', page_layout: :portrait,
      top_margin: 20, bottom_margin: 20, left_margin: 20, right_margin: 20)
    font "vendor/fonts/ipaexm.ttf"

    cover
    start_new_page
    disclaimer
    start_new_page
    content

  end

  def cover
    # Be cool more than this!
    default_leading 30
    text "高専ロボコンデータベース\nロボット保管状況",
      align: :center, valign: :center, size: 30
    move_down 38
    text "#{Time.current.strftime('%Y年%m月%d日 %H時%M分%S秒 JST 版')}",
      align: :center, valign: :center, size: 8
    move_down 400
    text "高専ロボコンデータベース製作委員会",
      align: :center, valign: :center, size: 20
  end

  def disclaimer
    pad = 5
    bounding_box(
      [pad, bounds.height - pad], :width => bounds.width - (pad * 2),
      :height => bounds.height - (pad * 2) ) do
      text "この資料は・・・\n", size: 11
      text "高専ロボコンデータベース製作委員会", align: :right, size: 11
      move_down 44
      text "This document ...", size: 11
      text "Kosen Robocon Database Development Commitee", align: :right, size: 11
    end
  end

  def content
    font_size 8
    table rows do
      cells.leading = 1
      cells.padding = 4
      cells.borders = [:bottom,]
      cells.border_width = 0.5
      row(0).border_width = 1.5
      row(-1).border_width = 1.5
      self.header = true
      self.row_colors = ['dddddd', 'ffffff']
      self.column_widths = [65,40,25,105,105,30,20,50,50,50]
      column(6).style align: :right
    end
  end

  def header
    text "高専ロボコンデータベース", size: 8
    stroke_color "eeeeee"
    stroke_line [0, 600], [530, 600]
  end

  def rows
    a = [["ロボットコード", "学校名", "状況", "ロボット名", "読み仮名",
      "年", "回", "全国大会", "地区大会", "備考" ]]
    @conditions.map.with_index do |r, i|
      s = r.fully_operational ? "動態" : "静態"
      prizes = PrizeHistory.where(robot_code: r.robot_code).includes(:prize).
          order("prize_histories.region_code ASC")
            # もっと速い方法にしたい
      p = {}
      p["national"] = prizes.select { |i| i.region_code == 0 }.map { |i|
        i.prize.name }.join("\n")
      p["regional"] = prizes.select { |i| i.region_code != 0 }.map { |i|
        i.prize.name }.join("\n")
      # if prizes.blank?
      #   a << [r.robot_code, r.robot.campus.abbreviation, s, r.robot.name,
      #     r.robot.kana, r.robot.contest_nth + 1987, r.robot.contest_nth,
      #     "", "", "" ]
      # else
      #   prizes.each_with_index do |p, i|
      #     if i == 0
      #       a << [r.robot_code, r.robot.campus.abbreviation, s, r.robot.name,
      #         r.robot.kana, r.robot.contest_nth + 1987, r.robot.contest_nth,
      #         p.prize.name, "", "" ]
      #     else
      #       a << ["", "", "", "", "", "", "", p.prize.name, "", ""]
      #     end
      #   end
      # end
      a << [r.robot_code, r.robot.campus.abbreviation, s, r.robot.name,
        r.robot.kana, r.robot.contest_nth + 1987, r.robot.contest_nth,
        p["national"], p["regional"], "" ]
    end
    return a
  end

  def footer

  end
end
