# frozen_string_literal: true

module Db
  class SlotPublishingsController < Db::ApplicationController
    include V4::ResourcePublishable

    before_action :authenticate_user!

    private

    def create_resource
      @create_resource ||= Slot.without_deleted.unpublished.find(params[:id])
    end

    def destroy_resource
      @destroy_resource ||= Slot.without_deleted.published.find(params[:id])
    end

    def after_created_path
      db_slot_list_path(create_resource.work)
    end

    def after_destroyed_path
      db_slot_list_path(destroy_resource.work)
    end
  end
end
