class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    callback_from :twitter
  end

  def callback_from(provider)
    provider = provider.to_s

    @user = User.find_or_create_by(user_params)
    @user.update(user_params_info)
    sign_in_and_redirect @user, :event => :authentication
    set_flash_message(:notice, :success, :kind => provider.capitalize) \
      if is_navigational_format? # sign_in_and_redirect の後でいいのかな？
  end

  private
    def user_params
      request.env["omniauth.auth"].slice('uid', 'provider')
    end

    def user_params_info
      request.env["omniauth.auth"]["info"].slice(
        'nickname', 'name', 'image', 'description'
      )
    end
end
