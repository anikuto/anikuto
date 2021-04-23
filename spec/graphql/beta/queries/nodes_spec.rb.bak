# frozen_string_literal: true

describe 'GraphQL API Query' do
  describe 'nodes' do
    let(:work1) { create(:work) }
    let(:work2) { create(:work) }
    let(:id1) { GraphQL::Schema::UniqueWithinType.encode(work1.class.name, work1.id) }
    let(:id2) { GraphQL::Schema::UniqueWithinType.encode(work2.class.name, work2.id) }
    let(:result) do
      query_string = <<~GRAPHQL
        query {
          nodes(ids: ["#{id1}", "#{id2}"]) {
            id
            ... on Work {
              anikutoId
              title
            }
          }
        }
      GRAPHQL

      res = Beta::AnikutoSchema.execute(query_string)
      pp(res) if res['errors']
      res
    end

    it 'fetches resources' do
      expected = {
        data: {
          nodes: [
            {
              id: id1,
              anikutoId: work1.id,
              title: work1.title
            },
            {
              id: id2,
              anikutoId: work2.id,
              title: work2.title
            }
          ]
        }
      }
      expect(result.to_h.deep_stringify_keys).to include(expected.deep_stringify_keys)
    end
  end
end
