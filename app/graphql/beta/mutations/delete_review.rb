# frozen_string_literal: true

module Beta
  module Mutations
    class DeleteReview < Beta::Mutations::Base
      argument :review_id, ID, required: true

      field :work, Beta::Types::Objects::WorkType, null: true

      def resolve(review_id:)
        raise Anikuto::Errors::InvalidAPITokenScopeError unless context[:doorkeeper_token].writable?

        work_record = context[:viewer].work_records.only_kept.find_by_graphql_id(review_id)
        work_record.record.destroy

        {
          work: work_record.work
        }
      end
    end
  end
end
