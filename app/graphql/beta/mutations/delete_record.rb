# frozen_string_literal: true

module Beta
  module Mutations
    class DeleteRecord < Beta::Mutations::Base
      argument :record_id, ID, required: true

      field :episode, Beta::Types::Objects::EpisodeType, null: true

      def resolve(record_id:)
        raise Anikuto::Errors::InvalidAPITokenScopeError unless context[:doorkeeper_token].writable?

        episode_record = context[:viewer].episode_records.only_kept.find_by_graphql_id(record_id)
        episode_record.record.destroy

        {
          episode: episode_record.episode
        }
      end
    end
  end
end
