# frozen_string_literal: true

describe Beta::Connections::ActivityConnection do
  let(:user) { create(:user) }
  let(:activity) { create(:create_episode_record_activity, user: user) }
  let!(:status) { create(:status, user: user) }
  let(:id) { GraphQL::Schema::UniqueWithinType.encode(user.class.name, user.id) }
  let(:result) do
    query_string = <<~GRAPHQL
      query {
        node(id: "#{id}") {
          id
          ... on User {
            username
            activities {
              edges {
                node {
                  ... on Record {
                    comment
                  }
                  ... on Status {
                    state
                  }
                }
              }
            }
          }
        }
      }
    GRAPHQL

    res = Beta::AnikutoSchema.execute(query_string)
    pp(res) if res['errors']
    res
  end

  it 'fetches activities' do
    expected = {
      data: {
        node: {
          id: id,
          username: user.username,
          activities: {
            edges: [
              {
                node: {
                  state: status.kind.upcase.to_s
                }
              },
              {
                node: {
                  comment: activity.itemable.body
                }
              }
            ]
          }
        }
      }
    }
    expect(result.to_h.deep_stringify_keys).to include(expected.deep_stringify_keys)
  end
end
