# frozen_string_literal: true

module Beta
  module Types
    module Objects
      class PrefectureType < Beta::Types::Objects::Base
        implements GraphQL::Relay::Node.interface

        global_id_field :id

        field :anikuto_id, Integer, null: false
        field :name, String, null: false
      end
    end
  end
end
