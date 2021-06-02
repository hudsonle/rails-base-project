class Admin::V1::BaseController < BaseController
  include AuthorizationHelper
  # include Admin::V1::Concerns::TrackingActivity
  # include Admin::V1::Concerns::DateTime

  before_action :authorize_admin_header_token

  protected

  # Get the model name from the controller. egs UsersController will return User
  def self.permission
    self.name.gsub("Controller", "").singularize.split("::").last.constantize.name rescue nil
  end

  def current_ability
    @current_ability ||= AdminAbility.new(@current_user)
  end
end
