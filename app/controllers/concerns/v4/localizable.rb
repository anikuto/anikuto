# frozen_string_literal: true

module V4
  module Localizable
    SKIP_TO_SET_LOCALE_PATHS = %w(
      /users/auth/gumroad/callback
    ).freeze
    private_constant :SKIP_TO_SET_LOCALE_PATHS

    private

    def set_locale(&action)
      return yield if request.path.in?(SKIP_TO_SET_LOCALE_PATHS)

      case [request.subdomain, request.domain].select(&:present?).join('.')
      when ENV.fetch('ANIKUTO_DOMAIN')
        I18n.with_locale(:en, &action)
      else
        I18n.with_locale(:ja, &action)
      end
    end

    def set_locale_with_params(&action)
      locale = current_user&.locale.presence || params[:locale].presence || :ja
      I18n.with_locale(locale, &action)
    end

    def locale_ja?
      locale.to_s == 'ja'
    end

    def locale_en?
      locale.to_s == 'en'
    end

    def local_url(locale: I18n.locale)
      return ENV.fetch('ANIKUTO_JP_URL') if locale.to_s == 'ja'

      ENV.fetch('ANIKUTO_URL')
    end

    def local_url_with_path(locale: I18n.locale)
      ["#{local_url(locale: locale)}#{request.path}", request.query_string].select(&:present?).join('?')
    end
  end
end
