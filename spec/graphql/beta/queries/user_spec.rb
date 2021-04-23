# frozen_string_literal: true

describe 'GraphQL API Query' do
  describe 'user' do
    let!(:user) { create(:user) }

    context 'when `username` argument is specified' do
      let(:result) do
        query_string = <<~QUERY
          query {
            user(username: "#{user.username}") {
              username
            }
          }
        QUERY

        res = Beta::AnikutoSchema.execute(query_string)
        pp(res) if res['errors']
        res
      end

      it "shows user's username" do
        expect(result.dig('data', 'user')).to eq(
          'username' => user.username
        )
      end
    end

    context '`activities` field' do
      context 'when `orderBy` argument is specified' do
        let!(:activity1) { create(:create_episode_record_activity, user: user) }
        let!(:activity2) { create(:create_episode_record_activity, user: user) }
        let!(:activity3) { create(:create_episode_record_activity, user: user) }
        let(:result) do
          query_string = <<~QUERY
            query {
              user(username: "#{user.username}") {
                username
                activities(orderBy: { field: CREATED_AT, direction: DESC }) {
                  edges {
                    anikutoId
                    action
                    node {
                      __typename
                    }
                  }
                }
              }
            }
          QUERY

          res = Beta::AnikutoSchema.execute(query_string)
          pp(res) if res['errors']
          res
        end

        it "shows ordered user's activities" do
          expect(result.dig('data', 'user')).to eq(
            'username' => user.username,
            'activities' => {
              'edges' => [
                {
                  'anikutoId' => activity3.id,
                  'action' => 'CREATE',
                  'node' => {
                    '__typename' => 'Record'
                  }
                },
                {
                  'anikutoId' => activity2.id,
                  'action' => 'CREATE',
                  'node' => {
                    '__typename' => 'Record'
                  }
                },
                {
                  'anikutoId' => activity1.id,
                  'action' => 'CREATE',
                  'node' => {
                    '__typename' => 'Record'
                  }
                }
              ]
            }
          )
        end
      end
    end

    context '`works` field' do
      context 'when `state` argument is specified' do
        let!(:status1) { create(:status, user: user, kind: :watching) }
        let!(:status2) { create(:status, user: user, kind: :watched) }
        let!(:work1) { status1.work }
        let!(:work2) { status2.work }
        let!(:library_entry1) { create(:library_entry, user: user, work: work1, status: status1) }
        let!(:library_entry2) { create(:library_entry, user: user, work: work2, status: status2) }
        let(:result) do
          query_string = <<~QUERY
            query {
              user(username: "#{user.username}") {
                username
                works(state: WATCHING) {
                  edges {
                    node {
                      title
                    }
                  }
                }
              }
            }
          QUERY

          res = Beta::AnikutoSchema.execute(query_string)
          pp(res) if res['errors']
          res
        end

        it "shows user's activities" do
          expect(result.dig('data', 'user')).to eq(
            'username' => user.username,
            'works' => {
              'edges' => [
                {
                  'node' => {
                    'title' => status1.work.title
                  }
                }
              ]
            }
          )
        end
      end
    end

    context '`avatar_url` field' do
      let(:result) do
        query_string = <<~QUERY
          query {
            user(username: "#{user.username}") {
              username
              avatarUrl
            }
          }
        QUERY

        res = Beta::AnikutoSchema.execute(query_string)
        pp(res) if res['errors']
        res
      end

      it "shows user's avatar image URL" do
        expect(result.dig('data', 'user')).to eq(
          'username' => user.username,
          'avatarUrl' => "#{ENV.fetch('ANIKUTO_API_ASSETS_URL')}/no-image.jpg"
        )
      end
    end
  end
end
