# frozen_string_literal: true

describe 'GET /works/:id', type: :request do
  context 'when user does not sign in' do
    let!(:work) { create(:work) }

    it 'responses work info' do
      get "/works/#{work.id}"

      expect(response.status).to eq(200)
      expect(response.body).to include(work.title)
    end
  end

  context 'when user signs in' do
    let!(:user) { create(:registered_user) }
    let!(:work) { create(:work) }

    before do
      login_as(user, scope: :user)
    end

    it 'responses series list' do
      get "/works/#{work.id}"

      expect(response.status).to eq(200)
      expect(response.body).to include(work.title)
    end
  end

  context 'when trailers are added' do
    let!(:work) { create(:work) }
    let!(:trailer) { create(:trailer, work: work) }

    before do
      get "/works/#{work.id}"
    end

    it 'displays trailer title' do
      expect(response.status).to eq(200)
      expect(response.body).to include(trailer.title)
    end
  end

  context 'when episodes have been added' do
    let!(:work) { create(:work) }
    let!(:episode) { create(:episode, work: work) }

    before do
      get "/works/#{work.id}"
    end

    it 'displays episode title' do
      expect(response.status).to eq(200)
      expect(response.body).to include(episode.title)
    end
  end

  context 'when characters have been added' do
    let!(:work) { create(:work) }
    let!(:cast) { create(:cast, work: work) }

    before do
      get "/works/#{work.id}"
    end

    it 'displays character name' do
      expect(response.status).to eq(200)
      expect(response.body).to include(cast.character.name)
    end
  end

  context 'when staffs (people) have been added' do
    let!(:work) { create(:work) }
    let!(:person) { create(:person) }
    let!(:staff) { create(:staff, work: work, resource: person) }

    before do
      get "/works/#{work.id}"
    end

    it 'displays staff name' do
      expect(response.status).to eq(200)
      expect(response.body).to include(staff.resource.name)
    end
  end

  context 'when staffs (organizations) have been added' do
    let!(:work) { create(:work) }
    let!(:organization) { create(:organization) }
    let!(:staff) { create(:staff, work: work, resource: organization) }

    before do
      get "/works/#{work.id}"
    end

    it 'displays staff name' do
      expect(response.status).to eq(200)
      expect(response.body).to include(staff.resource.name)
    end
  end

  context 'when vods have been added' do
    let!(:work) { create(:work) }
    let!(:channel) { create(:channel, vod: true) }
    let!(:program) { create(:program, work: work, channel: channel, vod_title_code: 'xxx') }
    let!(:vod_title_url) { "https://example.com/#{program.vod_title_code}" }

    before do
      allow_any_instance_of(Program).to receive(:vod_title_url).and_return(vod_title_url)

      get "/works/#{work.id}"
    end

    it 'can access to VOD service' do
      expect(response.status).to eq(200)
      expect(response.body).to include(vod_title_url)
    end
  end

  context 'when work records have been added' do
    let!(:work) { create(:work) }
    let!(:work_record) { create(:work_record, work: work) }

    before do
      get "/works/#{work.id}"
    end

    it 'displays work record body' do
      expect(response.status).to eq(200)
      expect(response.body).to include(work_record.body)
    end
  end

  context 'when series have been added' do
    let!(:work) { create(:work) }
    let!(:work2) { create(:work, :with_current_season) }
    let!(:series) { create(:series) }
    let!(:series_work) { create(:series_work, series: series, work: work) }
    let!(:series_work2) { create(:series_work, series: series, work: work2) }

    before do
      get "/works/#{work.id}"
    end

    it 'displays series' do
      expect(response.status).to eq(200)
      expect(response.body).to include(series_work.series.name)
      expect(response.body).to include(series_work2.series.name)
    end
  end
end
