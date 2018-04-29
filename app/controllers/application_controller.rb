class ApplicationController < ActionController::Base
  before_action :set_request_from
  protect_from_forgery with: :exception

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

  private
    def logged_in_user
      unless user_signed_in?
        flash[:danger] = "ログインしてください。"
        redirect_to root_path and return
      end

      unless !current_user.nil? && current_user.approved?
        flash[:danger] = "管理者の承認が必要です。"
        redirect_to root_path and return
      end
    end

    def admin_user
      unless !current_user.nil? && current_user.admin?
        flash[:danger] = "権限がありません。"
        redirect_to root_path and return
      end
    end
end
