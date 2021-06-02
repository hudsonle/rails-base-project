require 'json'

module AuthorizationHelper
  extend ActiveSupport::Concern

  protected

  def current_user
    @current_user
  end

  def authorize_admin_header_token
    auth_user     = Interactors::AuthorizeHeaderToken.new(:admin, request.headers).call
    @current_user = auth_user
    raise ErrorsHandler::Forbidden unless @current_user
  end
end
