require 'spec_helper'

describe OrganizationsController do
  let(:user) { create :user }

  before do
    sign_in user
  end

  describe "GET 'new'" do
    subject { get :new }

    it "returns success" do
      is_expected.to be_success
      expect(assigns(:organization)).to be_a_new Organization
    end
  end

  describe "POST 'create'" do
    subject { post :create, organization: params }

    let(:params) do
      { name: 'Organization Name' }
    end

    it 'redirects to organization page' do
      subject
      is_expected.to redirect_to dashboard_organization_path(user.organizations.first)
    end

    it 'creates organization' do
      expect { subject }.to change { Organization.count }.from(0).to(1)

      organization = Organization.last

      expect(organization.name).to eq 'Organization Name'
      expect(organization.users.first).to eq user
      expect(user.organizations.first).to eq organization
      expect(user).to be_configurable(organization)
    end

    context 'if invalid name is given' do
      let(:params) do
        { name: '' }
      end

      it 'does not create organizations' do
        expect {
          expect { subject }.to_not change { Organization.count }.from(0)
        }.to_not change { UserOrganization.count }.from(0)
      end

      it 'render new with error message' do
        is_expected.to render_template 'new'
        expect(assigns(:errors).size).to eq 2
      end
    end
  end

  describe "GET 'dashboard'" do
    let(:organization) { create :organization }

    subject { get :dashboard, id: organization.id }

    context 'if user is a organization member' do
      before do
        create :user_organization, organization: organization, user: user
      end

      it 'returns success' do
        is_expected.to be_success
        expect(assigns(:organization)).to eq organization
      end
    end

    context 'if user is not a organization member' do
      it { is_expected.to be_forbidden }
    end
  end

  describe "GET 'show'" do
    let(:organization) { create :organization }
    subject { get :show, id: organization_id }

    context 'if organization exists' do
      let(:organization_id) { organization.id }

      it 'returns success' do
        is_expected.to be_success
        expect(assigns(:organization)).to eq organization
      end
    end

    context 'if organization does not exist' do
      let(:organization_id) { 9999 }

      it 'redirects with error' do
        is_expected.to be_not_found
      end
    end
  end

  describe "GET 'search'" do
    let(:user) { create :user }

    before do
      sign_in user
    end

    subject { get :search, keyword: "MyOrganization" }

    context 'if user search organizations' do
      let(:organization) { create :organization }

      it 'returns success with organizations' do
        is_expected.to be_success
        expect(assigns(:organizations)).to eq [organization]
      end
    end
  end
end
