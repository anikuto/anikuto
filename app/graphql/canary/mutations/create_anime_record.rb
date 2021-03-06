# frozen_string_literal: true

module Canary
  module Mutations
    class CreateAnimeRecord < Canary::Mutations::Base
      argument :anime_id, ID,
        required: true
      argument :body, String,
        required: false,
        description: '作品への感想'
      argument :rating_overall_state, Canary::Types::Enums::RatingState,
        required: false,
        description: '作品への評価'
      argument :rating_animation_state, Canary::Types::Enums::RatingState,
        required: false,
        description: '作品への評価'
      argument :rating_music_state, Canary::Types::Enums::RatingState,
        required: false,
        description: '作品への評価'
      argument :rating_story_state, Canary::Types::Enums::RatingState,
        required: false,
        description: '作品への評価'
      argument :rating_character_state, Canary::Types::Enums::RatingState,
        required: false,
        description: '作品への評価'
      argument :share_to_twitter, Boolean,
        required: false,
        description: '作品への記録をTwitterでシェアするかどうか'

      field :anime_record, Canary::Types::Objects::AnimeRecordType, null: true

      def resolve(
        anime_id:,
        body: nil,
        rating_overall_state: nil,
        rating_animation_state: nil,
        rating_music_state: nil,
        rating_story_state: nil,
        rating_character_state: nil,
        share_to_twitter: nil
      )
        raise Anikuto::Errors::InvalidAPITokenScopeError unless context[:writable]

        viewer = context[:viewer]
        work = Work.only_kept.find_by_graphql_id(anime_id)

        work_record = viewer.work_records.new(
          body: body,
          rating_overall_state: rating_overall_state&.downcase,
          rating_animation_state: rating_animation_state&.downcase,
          rating_music_state: rating_music_state&.downcase,
          rating_story_state: rating_story_state&.downcase,
          rating_character_state: rating_character_state&.downcase,
          share_to_twitter: share_to_twitter
        )
        work_record.work = work
        work_record.detect_locale!(:body)

        ActiveRecord::Base.transaction do
          work_record.record = viewer.records.create!(work: work)

          unless work_record.valid?
            raise GraphQL::ExecutionError, work_record.errors.full_messages.join(', ')
          end

          work_record.save

          activity_group = viewer.create_or_last_activity_group!(work_record)
          viewer.activities.create!(itemable: work_record, activity_group: activity_group)

          viewer.update_share_record_setting(share_to_twitter)

          if viewer.share_record_to_twitter?
            viewer.share_work_record_to_twitter(work_record)
          end
        end

        {
          anime_record: work_record
        }
      end
    end
  end
end
