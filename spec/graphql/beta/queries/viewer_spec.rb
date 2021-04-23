# frozen_string_literal: true

describe 'GraphQL API Query' do
  describe 'viewer' do
    let(:user) { create(:user) }
    let(:result) do
      query_string = <<~GRAPHQL
        query {
          viewer {
            anikutoId
            username
          }
        }
      GRAPHQL

      res = Beta::AnikutoSchema.execute(query_string, context: { viewer: user })
      pp(res) if res['errors']
      res
    end

    it 'fetches user' do
      expected = {
        data: {
          viewer: {
            anikutoId: user.id,
            username: user.username
          }
        }
      }
      expect(result.to_h.deep_stringify_keys).to include(expected.deep_stringify_keys)
    end
  end
end
