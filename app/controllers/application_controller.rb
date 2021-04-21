# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit

  include ControllerCommon
  include Localable
  include Analyzable
  include LogrageSetting
  include Gonable
  include ViewSelector
  include FlashMessage
  include RavenContext
  include PageCategorizable
  include V4::UserDataFetchable

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, prepend: true

  helper_method :gon, :locale_ja?, :locale_en?, :local_url, :page_category

  around_action :switch_locale
  before_action :redirect_if_unexpected_subdomain
  before_action :set_search_params
  before_action :load_new_user
  before_action :store_data_into_gon

  # Action called when loading an image uploaded by Dragonfly when running a test
  # Since the image server is separated from this Rails application, when executing tests with CircleCI etc.
  # Call this dummy action as an image
  def dummy_image
    # The image doesn't have to be visible when running the test, so just return 200
    head 200
  end

  private

  def after_sign_in_path_for(resource)
    path = stored_location_for(resource)
    return path if path.present?

    root_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end
end
