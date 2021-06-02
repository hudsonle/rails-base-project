require 'json'

module AuthenticationAction
  extend ActiveSupport::Concern

  protected

  def verify_token
    payload = JWT.decode(
      jwt,
      OpenSSL::PKey::RSA.new(ENV['SSO_PUBLIC_KEY']),
      true,
      algorithm:  'RS256',
      verify_jti: true
    )[0]

    user_data = {
      id:         payload["user_id"],
      email:      payload["email"],
      first_name: payload["first_name"],
      last_name:  payload["last_name"],
    }

    User.current_token = http_auth_header
    User.current_user  = OpenStruct.new(user_data)
  rescue Exception => e
    Rails.logger.warn("[ERROR] verify_token: #{jwt} - #{e}")
    raise e
  end

  def current_user
    User.current_user
  end

  private

  # check for token in `Authorization` header
  def http_auth_header
    return request.headers["Authorization"] if request.headers["Authorization"].present?
    raise(ErrorsHandler::MissingToken, I18n.t("errors.missing_token"))
  end

  def jwt
    http_auth_header.split.last
  end
end
