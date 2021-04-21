# frozen_string_literal: true

module Db
  class ChannelGroupPublishingsController < Db::ApplicationController
    include V4::ResourcePublishable

    before_action :authenticate_user!

    private

    def create_resource
      @create_resource ||= ChannelGroup.without_deleted.unpublished.find(params[:id])
    end

    def destroy_resource
      @destroy_resource ||= ChannelGroup.without_deleted.published.find(params[:id])
    end

    def after_created_path
      db_channel_group_list_path
    end

    def after_destroyed_path
      db_channel_group_list_path
    end
  end
end
