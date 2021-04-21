# frozen_string_literal: true

module Localable
  private

  def locale_ja?
    locale.to_s == 'ja'
  end

  def locale_en?
    locale.to_s == 'en'
  end

  def local_url(locale: I18n.locale)
    case locale.to_s
    when 'ja'
      ENV.fetch('ANIKUTO_JP_URL')
    else
      ENV.fetch('ANIKUTO_URL')
    end
  end

  def local_current_url(locale: I18n.locale)
    ["#{local_url(locale: locale)}#{request.path}", request.query_string].select(&:present?).join('?')
  end

  def domain_jp?
    request.domain == ENV.fetch('ANIKUTO_JP_DOMAIN')
  end
end
