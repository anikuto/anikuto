# frozen_string_literal: true

module Beta
  module Types
    module Objects
      class Query < Beta::Types::Objects::Base
        field :node, field: GraphQL::Relay::Node.field
        field :nodes, field: GraphQL::Relay::Node.plural_field
        field :viewer, Beta::Types::Objects::UserType, null: true

        field :user, Beta::Types::Objects::UserType, null: true do
          argument :username, String, required: true
        end

        field :search_works, Beta::Types::Objects::WorkType.connection_type, null: true do
          argument :anikuto_ids, [Integer], required: false
          argument :seasons, [String], required: false
          argument :titles, [String], required: false
          argument :order_by, Beta::Types::InputObjects::WorkOrder, required: false
        end

        field :search_episodes, Beta::Types::Objects::EpisodeType.connection_type, null: true do
          argument :anikuto_ids, [Integer], required: false
          argument :order_by, Beta::Types::InputObjects::EpisodeOrder, required: false
        end

        field :search_people, Beta::Types::Objects::PersonType.connection_type, null: true do
          argument :anikuto_ids, [Integer], required: false
          argument :names, [String], required: false
          argument :order_by, Beta::Types::InputObjects::PersonOrder, required: false
        end

        field :search_organizations, Beta::Types::Objects::OrganizationType.connection_type, null: true do
          argument :anikuto_ids, [Integer], required: false
          argument :names, [String], required: false
          argument :order_by, Beta::Types::InputObjects::OrganizationOrder, required: false
        end

        field :search_characters, Beta::Types::Objects::CharacterType.connection_type, null: true do
          argument :anikuto_ids, [Integer], required: false
          argument :names, [String], required: false
          argument :order_by, Beta::Types::InputObjects::CharacterOrder, required: false
        end

        def viewer
          context[:viewer]
        end

        def user(username:)
          User.only_kept.find_by(username: username)
        end

        def search_works(anikuto_ids: nil, seasons: nil, titles: nil, order_by: nil)
          SearchWorksQuery.new(
            anikuto_ids: anikuto_ids,
            seasons: seasons,
            titles: titles,
            order_by: order_by
          ).call
        end

        def search_episodes(anikuto_ids: nil, order_by: nil)
          SearchEpisodesQuery.new(
            anikuto_ids: anikuto_ids,
            order_by: order_by
          ).call
        end

        def search_people(anikuto_ids: nil, names: nil, order_by: nil)
          SearchPeopleQuery.new(
            anikuto_ids: anikuto_ids,
            names: names,
            order_by: order_by
          ).call
        end

        def search_organizations(anikuto_ids: nil, names: nil, order_by: nil)
          SearchOrganizationsQuery.new(
            anikuto_ids: anikuto_ids,
            names: names,
            order_by: order_by
          ).call
        end

        def search_characters(anikuto_ids: nil, names: nil, order_by: nil)
          SearchCharactersQuery.new(
            anikuto_ids: anikuto_ids,
            names: names,
            order_by: order_by
          ).call
        end
      end
    end
  end
end
