# frozen_string_literal: true

module ErrorsHandler
  extend ActiveSupport::Concern

  class BadRequest < StandardError;
  end

  class SendEmailUnsuccessfully < StandardError;
  end

  class AdminDealRecordNotFound < StandardError;
  end

  class InvalidToken < StandardError;
  end

  class ExpiredSignature < StandardError;
  end

  class MissingToken < StandardError;
  end

  class MissingConfirmToken < StandardError;
  end

  class Forbidden < StandardError;
  end

  class Mt5RequestError < StandardError;
  end

  class HttpError < StandardError;
  end

  class ServiceUnAvailable < StandardError;
  end

  class ChargeInstallmentError < StandardError;
  end

  included do
    before_action :set_raven_context

    if Rails.env.production?
      rescue_from StandardError do |exception|
        Raven.capture_exception(exception)
        Rails.logger.error exception
        render json: json_with_error(
                       message: I18n.t("errors.internal_server_error"),
                     ), status: :internal_server_error
      end
    end

    # for APIs called from SSO system
    # rescue_from RestClient::ExceptionWithResponse do |exception|
    #   response = exception.response
    #   code = response.code
    #
    #   if code == 429
    #     render json: json_with_error(message: I18n.t("errors.too_many_requests")), status: code
    #   else
    #     response = JSON.parse(response)
    #     render json: json_with_error(message: response["message"] || response["error"]["message"],
    #                                  errors: response["errors"],
    #                                  error_code: response["error_code"] || (response["error"] && response["error"]["code"])), status: code
    #   end
    # end

    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
    rescue_from ActiveRecord::StatementInvalid, with: :handle_record_statement_invalid
    rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
    rescue_from ArgumentError, with: :handle_argument_error
    rescue_from BadRequest, with: :handle_bad_request
    rescue_from InvalidToken, with: :handle_bad_request
    rescue_from ExpiredSignature, with: :handle_bad_request
    rescue_from SendEmailUnsuccessfully, with: :send_email_unsuccessfully
    rescue_from MissingToken, with: :handle_missing_token
    rescue_from MissingConfirmToken, with: :handle_missing_confirm_token
    rescue_from Forbidden, with: :handle_forbidden
    rescue_from ActiveRecord::RecordNotUnique, with: :handle_duplicate_record
    rescue_from Mt5RequestError, with: :handle_mt5_request_error
  end

  protected

  def set_raven_context
    # Raven.user_context(id: current_user.try(:id))
    # Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  private

  def handle_mt5_request_error(exception)
    Raven.capture_message "[ERROR] MT5 request: #{exception}"
    render json: json_with_error(
                   message: I18n.t("errors.service_unavailable"),
                 ), status: :unprocessable_entity
  end

  def handle_record_invalid(exception)
    # Raven.capture_exception(exception)
    render json: json_with_error(
                   message: I18n.t("activerecord.errors.record_invalid", record: humanized_model_name(exception.record.class.to_s)),
                   errors:  exception.record&.errors&.messages,
                 ), status: :unprocessable_entity
  end

  def handle_record_not_found(exception)
    message = exception.model ? I18n.t("activerecord.errors.record_not_found", record: humanized_model_name(I18n.t("activerecord.model_names." + exception.model, default: exception.model))) : exception.message
    render json: json_with_error(
                   message: message,
                 ), status: :unprocessable_entity
  end

  def handle_record_statement_invalid(exception)
    Raven.capture_exception(exception)
    render json: json_with_error(
                   message: I18n.t("activerecord.errors.statement_invalid"),
                 ), status: :unprocessable_entity
  end

  def handle_parameter_missing(exception)
    # Raven.capture_exception(exception)
    render json: json_with_error(
                   message: I18n.t("activerecord.errors.parameters_missing"),
                 ), status: :bad_request
  end

  def handle_bad_request(exception)
    # Raven.capture_exception(exception)
    render json: json_with_error(
                   message: exception.message,
                 ), status: :bad_request
  end

  def handle_argument_error(exception)
    # Raven.capture_exception(exception)
    render json: json_with_error(
                   message: exception.message,
                 ), status: :unprocessable_entity
  end

  def humanized_model_name(model_name)
    model_name&.underscore&.humanize(keep_id_suffix: true) || "record"
  end

  def send_email_unsuccessfully(exception)
    render json: json_with_error(
                   message: exception.message,
                 ), status: :internal_server_error
  end

  def handle_missing_token
    render json: json_with_error(
                   message: I18n.t("errors.missing_token"),
                 ), status: :forbidden
  end

  def handle_missing_confirm_token
    render json: json_with_error(
                   message: I18n.t('errors.missing_confirm_token')
                 ), status: :forbidden
  end

  def handle_forbidden
    render json: json_with_error(
                   message: I18n.t("errors.forbidden"),
                 ), status: :forbidden
  end

  def handle_duplicate_record(exception)
    render json: json_with_error(
                   message: I18n.t("activerecord.errors.record_existed"),
                 ), status: :bad_request
  end

  def handle_access_denied(exception)
    render json: json_with_error(
                   message: exception.message,
                 ), status: :forbidden
  end
end
