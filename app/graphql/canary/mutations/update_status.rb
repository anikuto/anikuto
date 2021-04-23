# frozen_string_literal: true

module Canary
  module Mutations
    class UpdateStatus < Canary::Mutations::Base
      argument :anime_id, ID, required: true
      argument :kind, Canary::Types::Enums::StatusKind, required: true

      field :anime, Canary::Types::Objects::AnimeType, null: true

      def resolve(anime_id:, kind:)
        raise Anikuto::Errors::InvalidAPITokenScopeError unless context[:writable]

        viewer = context[:viewer]
        work = Work.only_kept.find_by_graphql_id(anime_id)

        library_entry = viewer.library_entries.find_by(work: work)

        if kind == 'NO_STATUS'
          ActiveRecord::Base.transaction do
            library_entry&.update!(status_id: nil)
            UserWatchedWorksCountJob.perform_later(viewer.id)
          end

          return {
            anime: work
          }
        end

        v2_kind = Status.kind_v3_to_v2(kind.downcase)
        status = viewer.statuses.new(work: work, kind: v2_kind)

        ActiveRecord::Base.transaction do
          status.save!
          status.save_library_entry
          status.update_channel_work

          activity_group = viewer.create_or_last_activity_group!(status)
          viewer.activities.create!(itemable: status, activity_group: activity_group)

          prev_state_kind = library_entry&.status&.kind
          viewer.update_works_count!(prev_state_kind, v2_kind)
          work.update_watchers_count!(prev_state_kind, v2_kind)

          UserWatchedWorksCountJob.perform_later(viewer.id)
          status.share_to_sns
        end

        {
          anime: work
        }
      end
    end
  end
end
