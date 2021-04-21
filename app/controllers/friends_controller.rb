# frozen_string_literal: true

class FriendsController < ApplicationController
  before_action :load_i18n, only: %i(index)
  before_action :authenticate_user!

  def index
    me_and_following_ids = current_user.followings.only_kept.pluck(:id) << current_user.id

    begin
      friend_ids = current_user.social_friends.all.pluck(:id)
      not_following_friend_ids = friend_ids - me_and_following_ids
      @friends = User.only_kept.where(id: not_following_friend_ids).sample(20)
    rescue Koala::Facebook::AuthenticationError
      message = 'The session with Facebook has expired. Please re-link.'
      return redirect_to providers_path, alert: message
    end

    user_ids = (User.pluck(:id) - (me_and_following_ids + @friends.map(&:id)))
    @users = User.only_kept.where(id: user_ids).past_month(field: :current_sign_in_at).sample(20)
  end

  private

  def load_i18n
    keys = {
      "verb.follow": nil,
      "noun.following": nil
    }

    load_i18n_into_gon keys
  end
end
