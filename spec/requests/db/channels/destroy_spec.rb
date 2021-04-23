# frozen_string_literal: true

describe 'DELETE /db/channels/:id', type: :request do
  context 'user does not sign in' do
    let!(:channel) { create(:channel, :not_deleted) }

    it 'user can not access this page' do
      expect(Channel.count).to eq(1)

      delete "/db/channels/#{channel.id}"
      channel.reload

      expect(response.status).to eq(302)
      expect(flash[:alert]).to eq('ログインしてください')

      expect(Channel.count).to eq(1)
    end
  end

  context 'user who is not editor signs in' do
    let!(:user) { create(:registered_user) }
    let!(:channel) { create(:channel, :not_deleted) }

    before do
      login_as(user, scope: :user)
    end

    it 'user can not access' do
      expect(Channel.count).to eq(1)

      delete "/db/channels/#{channel.id}"
      channel.reload

      expect(response.status).to eq(302)
      expect(flash[:alert]).to eq('アクセスできません')

      expect(Channel.count).to eq(1)
    end
  end

  context 'user who is editor signs in' do
    let!(:user) { create(:registered_user, :with_editor_role) }
    let!(:channel) { create(:channel, :not_deleted) }

    before do
      login_as(user, scope: :user)
    end

    it 'user can not access' do
      expect(Channel.count).to eq(1)

      delete "/db/channels/#{channel.id}"
      channel.reload

      expect(response.status).to eq(302)
      expect(flash[:alert]).to eq('アクセスできません')

      expect(Channel.count).to eq(1)
    end
  end

  context 'user who is admin signs in' do
    let!(:user) { create(:registered_user, :with_admin_role) }
    let!(:channel) { create(:channel, :not_deleted) }

    before do
      login_as(user, scope: :user)
    end

    it 'user can delete channel softly' do
      expect(Channel.count).to eq(1)

      delete "/db/channels/#{channel.id}"

      expect(response.status).to eq(302)
      expect(flash[:notice]).to eq('削除しました')

      expect(Channel.count).to eq(0)
    end
  end
end
