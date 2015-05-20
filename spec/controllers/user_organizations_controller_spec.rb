require 'spec_helper'

describe UserOrganizationsController do
  describe "GET 'index'" do
    let(:user) { create :user }

    before do
      sign_in user
    end

    subject { get :index, user_id: user.id }

    context 'if user joins organizations' do
      let(:organization) { create :organization }

      before do
        create :user_organization, user: user, organization: organization
      end

      it 'returns success with organizations' do
        is_expected.to be_success
        expect(assigns(:organizations)).to eq [organization]
      end
    end

    context 'if user does not join organizations' do
      it 'returns success without organizations' do
        is_expected.to be_success
        expect(assigns(:organizations)).to eq []
      end
    end
  end
end
