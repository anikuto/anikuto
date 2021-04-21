# frozen_string_literal: true

describe "DELETE /db/staffs/:id", type: :request do
  context "user does not sign in" do
    let!(:staff) { create(:staff, :not_deleted) }

    it "user can not access this page" do
      expect(Staff.count).to eq(1)

      delete "/db/staffs/#{staff.id}"
      staff.reload

      expect(response.status).to eq(302)
      expect(flash[:alert]).to eq("ログインしてください")

      expect(Staff.count).to eq(1)
    end
  end

  context "user who is not editor signs in" do
    let!(:user) { create(:registered_user) }
    let!(:staff) { create(:staff, :not_deleted) }

    before do
      login_as(user, scope: :user)
    end

    it "user can not access" do
      expect(Staff.count).to eq(1)

      delete "/db/staffs/#{staff.id}"
      staff.reload

      expect(response.status).to eq(302)
      expect(flash[:alert]).to eq("アクセスできません")

      expect(Staff.count).to eq(1)
    end
  end

  context "user who is editor signs in" do
    let!(:user) { create(:registered_user, :with_editor_role) }
    let!(:staff) { create(:staff, :not_deleted) }

    before do
      login_as(user, scope: :user)
    end

    it "user can not access" do
      expect(Staff.count).to eq(1)

      delete "/db/staffs/#{staff.id}"
      staff.reload

      expect(response.status).to eq(302)
      expect(flash[:alert]).to eq("アクセスできません")

      expect(Staff.count).to eq(1)
    end
  end

  context "user who is admin signs in" do
    let!(:user) { create(:registered_user, :with_admin_role) }
    let!(:staff) { create(:staff, :not_deleted) }

    before do
      login_as(user, scope: :user)
    end

    it "user can delete staff softly" do
      expect(Staff.count).to eq(1)

      delete "/db/staffs/#{staff.id}"

      expect(response.status).to eq(302)
      expect(flash[:notice]).to eq("削除しました")

      expect(Staff.count).to eq(0)
    end
  end
end
