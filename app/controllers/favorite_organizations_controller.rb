# frozen_string_literal: true

class FavoriteOrganizationsController < ApplicationController
  before_action :load_i18n, only: %i(index)

  def index
    set_page_category Rails.configuration.page_categories.favorite_organization_list

    @user = User.only_kept.find_by!(username: params[:username])
    @user_entity = UserEntity.from_model(@user)
    @organization_favorites = @user.
      organization_favorites.
      preload(:organization).
      order(watched_works_count: :desc)
  end

  private

  def load_i18n
    keys = {
      "messages._components.favorite_button.add_to_favorites": nil,
      "messages._components.favorite_button.added_to_favorites": nil
    }

    load_i18n_into_gon keys
  end
end
