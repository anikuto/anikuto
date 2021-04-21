# frozen_string_literal: true

module LocalHelper
  def local_domain(locale: I18n.locale)
    case locale.to_s
    when 'en'
      ENV.fetch('ANIKUTO_DOMAIN')
    else
      ENV.fetch('ANIKUTO_JP_DOMAIN')
    end
  end
end
