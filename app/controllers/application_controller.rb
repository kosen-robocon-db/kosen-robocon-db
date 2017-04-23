class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

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
