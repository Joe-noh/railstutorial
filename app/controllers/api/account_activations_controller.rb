class Api::AccountActivationsController < Api::ApplicationController

  def edit
    @user = User.find_by(email: params[:email])
    if @user && !(activated = @user.activated?) &&
        (authenticated = @user.authenticated?(:activation, params[:id]))
      @user.activate
      render_authenticated @user, status: :ok
    else
      if !@user
        render_errors [t("error.user_not_found")], status: :not_found
      elsif activated
        render_errors [t("error.already_activated")], status: :unprocessable_entity
      elsif !authenticated
        render_errors [t("error.invalid_activation_token")], status: :not_found
      end
    end
  end
end
