# frozen_string_literal: true

class IcsController < ApplicationController
  def show
    @user = User.only_kept.find_by!(username: params[:username])

    I18n.with_locale(@user.locale) do
      @slots = UserSlotsQuery.new(
        @user,
        Slot.only_kept.with_works(@user.works_on(:wanna_watch, :watching).only_kept),
        watched: false
      ).call.
        where('started_at >= ?', Date.today.beginning_of_day).
        where('started_at <= ?', 7.days.since.end_of_day)

      @works = @user.
        works_on(:wanna_watch, :watching).
        only_kept.
        where.not(started_on: nil)

      render layout: false
    end
  end
end
