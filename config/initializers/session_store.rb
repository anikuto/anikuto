# frozen_string_literal: true
# Be sure to restart your server when you modify this file.

Anikuto::Application.config.session_store :active_record_store,
  key: '_anikuto_session',
  domain: :all,
  expire_after: 30.days
