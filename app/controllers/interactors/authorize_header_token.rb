class Interactors::AuthorizeHeaderToken
  def initialize(type, headers = {})
    @type    = type
    @headers = headers
  end

  # Service entry point - return valid user object
  def call
    data               = get_user.merge(is_admin: admin?)
    User.current_token = http_auth_header
    User.current_user  = OpenStruct.new(data)
    data
  end

  private

  attr_reader :headers, :type

  def get_user
    response = Interactors::Sso::Admins::Authentications.me(http_auth_header, I18n.locale) if admin?
    raise(ErrorsHandler::BadRequest, JSON.parse(response)['message']) if response.code != 200
    JSON.parse(response)['data']
  end

  # check for token in `Authorization` header
  def http_auth_header
    return headers["Authorization"] if headers["Authorization"].present?
    raise(ErrorsHandler::MissingToken, I18n.t("errors.missing_token"))
  end

  def admin?
    type == :admin
  end
end
