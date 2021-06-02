# frozen_string_literal: true

class LocaleUtils
  def initialize(resource, env, lang = nil)
    @resource = resource
    @env = env
    @lang = lang
  end

  def set_locale
    I18n.locale = extract_locale
    # if @resource && @resource.language != I18n.locale.to_s
    #   @resource.update_attribute(:language, I18n.locale)
    # end
  end

  private

  def extract_locale
    available_locales = I18n.available_locales.map(&:to_s)
    @lang.presence_in(available_locales) ||
      @resource.try(:language).presence_in(available_locales) ||
      extract_locale_from_accept_language_header.presence_in(available_locales) || I18n.default_locale
  end

  def extract_locale_from_accept_language_header
    @env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first
  end
end
