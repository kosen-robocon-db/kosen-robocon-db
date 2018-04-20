module ApplicationHelper

  def base_title
    "高専ロボコンデータベース"
  end

  def full_title(page_title = '')
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def alert_type_convert(type)
    case type
    when "notice"
      "success"
    when "alert"
      "danger"
    when "success","info","warning","danger"
      type
    else
      "info"
    end
  end

end
