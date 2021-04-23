# frozen_string_literal: true

class FooterComponent < ApplicationComponent
  include ApplicationHelper

  private

  def social_urls
    [
      ["https://twitter.com/#{helpers.twitter_username}", 'twitter'],
      ['https://github.com/anikuto', 'github'],
      [ENV.fetch('ANIKUTO_DISCORD_INVITE_URL'), 'discord']
    ]
  end

  def service_urls
    [
      [userland_root_path, t('noun.anikuto_userland')],
      [forum_root_path, t('noun.anikuto_forum')],
      [db_root_path, t('noun.anikuto_db')],
      ['https://developers.anikuto.com', t('noun.anikuto_developers')],
      [supporters_path, t('noun.anikuto_supporters')]
    ]
  end

  def content_urls
    [
      [faqs_path, t('head.title.faqs.index'), true],
      [about_path, t('head.title.pages.about'), false],
      [terms_path, t('noun.terms_of_use'), true],
      [privacy_path, t('noun.privacy_policy'), true],
      [legal_path, t('head.title.pages.legal'), true]
    ]
  end
end
