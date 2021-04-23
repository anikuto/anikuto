# frozen_string_literal: true

describe 'GraphQL API Query' do
  describe 'searchEpisodes' do
    let!(:work) { create(:work, :with_current_season) }
    let!(:episode1) { create(:episode, work: work, sort_number: 1) }
    let!(:episode2) { create(:episode, work: work, sort_number: 3) }
    let!(:episode3) { create(:episode, work: work, sort_number: 2) }

    context 'when `anikutoIds` argument is specified' do
      let(:result) do
        query_string = <<~QUERY
          query {
            searchEpisodes(anikutoIds: [#{episode1.id}]) {
              edges {
                node {
                  anikutoId
                  title
                }
              }
            }
          }
        QUERY

        res = Beta::AnikutoSchema.execute(query_string)
        pp(res) if res['errors']
        res
      end

      it 'shows episode' do
        expect(result.dig('data', 'searchEpisodes', 'edges')).to match_array(
          [
            {
              'node' => {
                'anikutoId' => episode1.id,
                'title' => episode1.title
              }
            }
          ]
        )
      end
    end

    context 'when `orderBy` argument is specified' do
      let(:result) do
        query_string = <<~QUERY
          query {
            searchEpisodes(orderBy: { field: SORT_NUMBER, direction: DESC }) {
              edges {
                node {
                  anikutoId
                  title
                  sortNumber
                }
              }
            }
          }
        QUERY

        res = Beta::AnikutoSchema.execute(query_string)
        pp(res) if res['errors']
        res
      end

      it 'shows ordered episodes' do
        expect(result.dig('data', 'searchEpisodes', 'edges')).to match_array(
          [
            {
              'node' => {
                'anikutoId' => episode2.id,
                'title' => episode2.title,
                'sortNumber' => 3
              }
            },
            {
              'node' => {
                'anikutoId' => episode3.id,
                'title' => episode3.title,
                'sortNumber' => 2
              }
            },
            {
              'node' => {
                'anikutoId' => episode1.id,
                'title' => episode1.title,
                'sortNumber' => 1
              }
            }
          ]
        )
      end
    end

    context 'when `recodes` are fetched' do
      let!(:record) { create(:episode_record, episode: episode1) }
      let(:result) do
        query_string = <<~QUERY
          query {
            searchEpisodes(orderBy: { field: SORT_NUMBER, direction: ASC }, first: 1) {
              edges {
                node {
                  anikutoId
                  records {
                    edges {
                      node {
                        anikutoId
                        comment
                      }
                    }
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

      it 'shows records' do
        expect(result.dig('data', 'searchEpisodes', 'edges')).to match_array(
          [
            {
              'node' => {
                'anikutoId' => episode1.id,
                'records' => {
                  'edges' => [
                    {
                      'node' => {
                        'anikutoId' => record.id,
                        'comment' => record.body
                      }
                    }
                  ]
                }
              }
            }
          ]
        )
      end
    end
  end
end
