class Api::StardomController < Api::ApplicationController
  include DateTimeHelper

  before_action :set_current_user

  def show
    today = shifted_date

    if active = Star.active?(today)
      status = current_user.star_status || :stargazer
    end

    render json: {active: active, star_status: status}
  end
end
