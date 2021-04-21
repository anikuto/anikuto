# frozen_string_literal: true

module Anikuto
  module Analytics
    class Client
      attr_writer :page_category, :user

      def initialize(request, user)
        @request = request
        @user = user
      end

      def events
        @event ||= Anikuto::Analytics::Event.new(@request, @user, params)
      end

      private

      def params
        {
          page_category: @page_category
        }
      end
    end
  end
end
