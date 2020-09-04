class OmniauthController <  Devise::OmniauthCallbacksController

  def github
    @user = User.create_from_provider_data(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      flash[:error] = 'There was a problem signing you in. Please try again later'
      redirect_to root_path
    end
  end

  def failure
    flash[:error] = 'There was a problem signing you in. Please try again later'
    redirect_to root_path
  end
end
