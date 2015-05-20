require 'spec_helper'

describe ProjectsController do
  let(:user) { create :user }

  before do
    sign_in user
  end

  describe "GET 'new'" do
    subject { get :new, organization_id: organization.id }

    let(:organization) { create :organization }
    let!(:user_organization) do
      create :user_organization, user: user, organization: organization
    end

    it do
      is_expected.to be_success
      expect(assigns(:project)).to be_a_new(Project)
    end

    context 'if user is not a member of organization' do
      before do
        user_organization.destroy
      end

      it { is_expected.to be_not_found }
    end
  end

  describe "GET 'show'" do
    subject { get :show, id: project.id, organization_id: organization.id }

    let(:project) { create :project }
    let(:organization) { project.organization }
    let!(:user_organization) do
      create :user_organization, user: user, organization: organization
    end
    let!(:user_project) do
      create :user_project, user: user, project: project
    end

    it do
      is_expected.to be_success
      expect(assigns(:project)).to eq project
    end

    context 'if project does not belongs organization' do
      let(:organization) { create :organization }

      it { is_expected.to be_not_found }
    end

    context 'if user is not a member of organization' do
      before do
        user_organization.destroy
      end

      it { is_expected.to be_not_found }
    end

    context 'if user is not a member of project' do
      before do
        user_project.destroy
      end

      it { is_expected.to be_forbidden }
    end
  end

  describe "POST 'create'" do
    subject do
      post :create, organization_id: organization.id, project: project_params
    end

    let(:organization) { create :organization }
    let!(:user_organization) do
      create :user_organization, user: user, organization: organization
    end

    let(:project_params) do
      { name: 'name' }
    end

    it 'creates project' do
      expect { subject }.to change { Project.count }.from(0).to(1)

      project = Project.last
      expect(project.name).to eq 'name'
      expect(project.organization).to eq organization

      expect(user).to be_member_of(project)
      expect(user).to be_configurable(project)

      is_expected.to redirect_to organization_project_path(
        project, organization_id: organization.id
      )
    end

    context 'if name is not given' do
      before do
        project_params[:name] = nil
      end

      it do
        is_expected.to render_template :new
        expect(assigns(:errors).size).to eq 1
      end
    end
  end
end
