module ApplicationHelper

  before_filter :set_request_from

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

  # セッションのリクエスト元を保存しておく
  def set_request_from
    if session[:request_from]
      @request_from = session[:request_from]
    end
    # 現在のURLを保存しておく
    session[:request_from] = request.original_url
  end

  # 前の画面に戻る
  def return_back
    if request.referer
      redirect_to :back and return true
    elsif @request_from
      redirect_to @request_from and return true
    end
  end

end
