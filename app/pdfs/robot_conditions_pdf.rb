class RobotConditionsPDF < Prawn::Document

  TITLE = "高専ロボコンデータベース ロボット保管状況"
  COPYRIGHT_HOLDER = "高専ロボコンデータベース製作委員会"
  FONT = "vendor/fonts/ipaexg.ttf"

  def initialize(robot_conditions:)
    @conditions = robot_conditions
    super(page_size: 'A4', page_layout: :portrait,
      top_margin: 20, bottom_margin: 20, left_margin: 20, right_margin: 20)
    @date_time_version =
      "#{Time.current.strftime('%Y年%m月%d日 %H時%M分%S秒 JST 版')}"

    font FONT

    cover
    start_new_page
    disclaimer
    start_new_page
    content
    page_header
    page_footer
  end

  def cover
    # Be cool more than this!
    default_leading 30
    text TITLE.gsub(/ /, "\n"),
      align: :center, valign: :center, size: 30
    move_down 38
    text @date_time_version,
      align: :center, valign: :center, size: 8
    move_down 400
    text COPYRIGHT_HOLDER,
      align: :center, valign: :center, size: 20
  end

  def disclaimer
    pad = 5
    bounding_box(
      [pad, bounds.height - pad], :width => bounds.width - (pad * 2),
      :height => bounds.height - (pad * 2) ) do
      text "この資料は・・・", size: 11
      text "高専ロボコンデータベース製作委員会", align: :right, size: 11
      move_down 44
      text "This document ...", size: 11
      text "Kosen Robocon Database Development Commitee", align: :right, size: 11
    end
  end

  def page_header
    repeat lambda { |page| page > 2 } do
      draw_text TITLE + "  " + @date_time_version + "  " + COPYRIGHT_HOLDER,
        at: bounds.top_left, size: 8
    end
  end

  def content
    font_size 8
    table rows do
      cells.leading = 1
      cells.padding = 4
      cells.borders = [ :bottom ]
      cells.border_width = 0.5
      row(0).border_width = 1.5
      row(-1).border_width = 1.5
      self.header = true
      self.row_colors = [ 'dddddd', 'ffffff' ]
      self.column_widths = [ 65, 40, 25, 105, 105, 30, 20, 50, 50, 50 ]
      column(6).style align: :right
    end
  end

  def rows
    a = [["ロボットコード", "学校名", "状況", "ロボット名", "読み仮名",
      "年", "回", "全国大会", "地区大会", "備考" ]]
    @conditions.map.with_index do |r, i|
      s = r.fully_operational ? "動態" : "静態"
      prizes = PrizeHistory.where(robot_code: r.robot_code).includes(:prize).
          order("prize_histories.region_code ASC") # もっと速い方法にしたい
      p = {}
      p["national"] = prizes.select { |i| i.region_code == 0 }.map { |i|
        i.prize.name }.join("\n")
      p["regional"] = prizes.select { |i| i.region_code != 0 }.map { |i|
        i.prize.name }.join("\n")
      a << [r.robot_code, r.robot.campus.abbreviation, s, r.robot.name,
        r.robot.kana, r.robot.contest_nth + 1987, r.robot.contest_nth,
        p["national"], p["regional"], "" ]
    end
    return a
  end

  def page_footer
    # disclaimerの次のページ番号を1にするにはどうしたらよいのか？
    string = '<page> / <total>'
    options = {
      at: [ bounds.width / 2, 0 ],
      page_filter: lambda { |page| page > 2 },
      start_count_at: 3,
      size: 8
    }
    number_pages string, options
  end

end
