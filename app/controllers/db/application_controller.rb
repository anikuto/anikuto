# frozen_string_literal: true

module Db
  class ApplicationController < ActionController::Base
    include Pundit

    include PageCategorizable
    include V4::RavenContext
    include V4::Loggable
    include V4::Localizable

    layout "db"

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    helper_method :client_uuid, :locale_en?, :locale_ja?, :page_category

    before_action :set_raven_context
    before_action :set_search_params
    around_action :set_locale

    private

    def set_search_params
      @search = SearchService.new(params[:q], scope: :all)
    end

    def user_not_authorized
      flash[:alert] = t "messages._common.you_can_not_access_there"
      redirect_to(request.referrer || db_root_path)
    end
  end
end
