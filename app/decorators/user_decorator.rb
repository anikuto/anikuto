# frozen_string_literal: true

module UserDecorator
  def name_link(options = {})
    link_to(profile.name, anikuto_url(:profile_detail_url, username), options)
  end

  def role_badge
    return '' unless committer?

    content_tag(:span, class: 'u-badge-outline u-badge-outline-dark') do
      role_text
    end
  end

  def name_with_username
    "#{profile.name} (@#{username})"
  end
end
