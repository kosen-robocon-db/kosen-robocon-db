class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    @user = User.find_or_create_by(user_params)
    @user.update(user_params_info)
    sign_in_and_redirect @user, :event => :authentication
    set_flash_message(:notice, :success, :kind => "Twitter") if is_navigational_format?
  end

  private
    def user_params
      request.env["omniauth.auth"].slice(:uid, :provider).to_h
    end

    def user_params_info
      request.env["omniauth.auth"]["info"].slice(:nickname, :name, :image, :description).to_h
    end
end
