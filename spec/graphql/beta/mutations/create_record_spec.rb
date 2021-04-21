# frozen_string_literal: true

describe "GraphQL API Mutation" do
  describe "createRecord" do
    let!(:episode) { create(:episode) }
    let!(:user) { create(:user, :with_setting) }
    let!(:token) { create(:oauth_access_token) }
    let!(:context) { { viewer: user, doorkeeper_token: token } }
    let!(:id) { GraphQL::Schema::UniqueWithinType.encode(episode.class.name, episode.id) }
    let!(:body) { "とてもよかった！" }
    let!(:result) do
      query_string = <<~GRAPHQL
        mutation {
          createRecord(input: {
            comment: "#{body}",
            episodeId: "#{id}",
            ratingState: GOOD
          }) {
            record {
              ... on Record {
                id
                anikutoId
                comment
                ratingState
              }
            }
          }
        }
      GRAPHQL

      res = Beta::AnikutoSchema.execute(query_string, context: context)
      pp(res) if res["errors"]
      res
    end

    before do
      result
    end

    it "create episode record" do
      episode_record = EpisodeRecord.last
      expect(result.dig("data", "createRecord", "record", "anikutoId")).to eq(episode_record.id)
      expect(result.dig("data", "createRecord", "record", "comment")).to eq(episode_record.body)
      expect(result.dig("data", "createRecord", "record", "ratingState")).to eq("GOOD")
    end
  end
end
