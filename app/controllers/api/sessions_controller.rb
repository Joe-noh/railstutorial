class Api::SessionsController < Api::ApplicationController
  include Api::SessionsHelper

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        render_authenticated @user, status: :created
      else
        render_errors [t("error.account_not_activated")], status: :forbidden
      end
    else
      render_errors [t("error.invalid_email_password")], status: :unauthorized
    end
  end
end
