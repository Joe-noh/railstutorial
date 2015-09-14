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

  def update
    today = shifted_date

    accept = params[:stardom] && params[:stardom][:accept]
    if accept != 'true' && accept != 'false'
      render_errors ['Unacceptable value for stardom[accept]'], status: :bad_request
    else
      if star = current_user.stars.find_by(date: today)
        star.update(status: (accept != 'false' ? :accepted : :declined))
        render json: {}, status: :ok
      else
        render_errors ['You are not elected for a star.'], status: :forbidden
      end
    end
  end
end
