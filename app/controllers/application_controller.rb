class ApplicationController < ActionController::API
  include ResponseHelper
  include ErrorsHandler

  before_action :set_locale

  def render_200
    render json: json_with_success(message: "OK"), status: :ok
  end

  # using to response 404 status to client in case no route found
  def render_404
    render json: json_with_error(message: I18n.t("errors.no_route_found")), status: :not_found
  end

  private
  def set_locale
    ::LocaleUtils.new(nil, request.env, params[:lang]).set_locale
  end
end
