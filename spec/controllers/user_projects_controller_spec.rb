require 'spec_helper'

describe UserProjectsController do
  let(:user) { create :user }

  before do
    sign_in user
  end

  describe "GET 'index'" do
    subject { get :index }

    let(:organization) { create :organization }
    let(:project) { create :project, organization: organization }

    before do
      create :user_organization, user: user, organization: organization, admin: true
    end

    context "if user joins project" do
      before do
        create :user_project, user: user, project: project, admin: true
      end
      it 'returns success with projects' do
        is_expected.to be_success
        expect(assigns(:projects)).to eq [project]
      end
    end

    context "if user does not join project" do
      it 'returns success without projects' do
        is_expected.to be_success
        expect(assigns(:projects)).to eq []
      end
    end
  end
end
