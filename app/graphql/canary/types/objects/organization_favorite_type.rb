# frozen_string_literal: true

module Canary
  module Types
    module Objects
      class OrganizationFavoriteType < Canary::Types::Objects::Base
        implements GraphQL::Relay::Node.interface

        field :user, Canary::Types::Objects::UserType, null: false
        field :organization, Canary::Types::Objects::OrganizationType, null: false
        field :watched_anime_count, Integer, null: false
        field :created_at, Canary::Types::Scalars::DateTime, null: false

        def user
          Canary::RecordLoader.for(User).load(object.user_id)
        end

        def organization
          Canary::RecordLoader.for(Organization).load(object.organization_id)
        end

        def watched_anime_count
          object.watched_works_count
        end
      end
    end
  end
end
