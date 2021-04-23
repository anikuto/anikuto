# frozen_string_literal: true

module Beta
  module Types
    module Objects
      class Base < GraphQL::Schema::Object
        include Imgix::Rails::UrlHelper
        include ImageHelper

        def anikuto_id
          object.id
        end

        def build_order(order_by)
          return Beta::OrderProperty.new unless order_by

          Beta::OrderProperty.new(order_by[:field], order_by[:direction])
        end
      end
    end
  end
end
