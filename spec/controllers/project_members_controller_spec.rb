require 'spec_helper'

describe ProjectMembersController do
  let(:user) { create :user }
  let(:organization) { create :organization }
  let(:project) { create :project, organization: organization }
  let(:project_id) { project.id }
  let(:target_user) { create :user, name: 'steve', email: 'target@example.com' }
  let(:target_user_id) { target_user.id }

  before do
    sign_in user
  end

  describe "POST 'create'" do
    subject do
      post :create, organization_id: organization.id, project_id: project_id, email: target_user_email
    end
    let(:target_user_email) { 'target@example.com' }

    before do
      create :user_organization, user: user, organization: organization, admin: admin
      create :user_project, user: user, project: project, admin: admin
    end

    context "current user is not admin" do
      let(:admin) { false }

      it { is_expected.to be_forbidden }
    end

    let(:admin) { true }
    context "target user does not belong to the organization." do
      it 'redirects with error' do
        is_expected.to redirect_to organization_project_path(organization, project)
        expect(flash[:email]).to eq 'target@example.com'
        expect(flash[:error]).to eq(
          I18n.t('controllers.project_members.create.user_not_found')
        )
      end
    end

    context "current user is admin" do
      before do
        create :user_organization, user: target_user, organization: organization, admin: admin
      end
      let(:admin) { true }

      it "shows successful message." do
        is_expected.to redirect_to organization_project_path(organization, project)
        expect(flash[:email]).to be_nil
        expect(flash[:message]).to eq(
          I18n.t('controllers.project_members.create.success', name: target_user.name)
        )
      end

      context "target user is not found." do
        let(:target_user_email) { 'nottarget@example.com' }
        it 'redirects with error' do
          is_expected.to redirect_to organization_project_path(organization, project)
          expect(flash[:email]).to eq target_user_email
          expect(flash[:error]).to eq(
            I18n.t('controllers.project_members.create.user_not_found')
          )
        end
      end

      context "if target user is already member." do
        before do
          create :user_project, user: target_user, project: project, admin: admin
        end
        it 'redirects without messeage' do
          is_expected.to redirect_to organization_project_path(organization, project)
          expect(flash[:email]).to be_nil
          expect(flash[:error]).to be_nil
        end
      end

      context "project does not belong to the organization" do
        let(:organization2) { create :organization }
        let(:project2) { create :project, organization: organization2 }
        let(:project_id) { project2.id }

        before do
          create :user_organization, user: user, organization: organization2, admin: admin
          create :user_project, user: user, project: project2, admin: admin
        end

        it { is_expected.to be_forbidden }
      end
    end
  end

  describe "DELETE 'destroy'" do
    before do
      create :user_organization, user: user, organization: organization, admin: admin
      create :user_project, user: user, project: project, admin: admin
    end

    subject do
      delete :destroy, organization_id: organization.id, project_id: project_id, id: target_user_id
    end

    context 'when user is an admin of the project' do
      let(:admin) { true }

      context 'if target user is not found' do
        let(:target_user_id) { 999999 }
        it { is_expected.to be_not_found }
      end

      context 'if target user is found' do
        context 'when user is the target user' do
          let(:target_user_id) { user.id }
          it { is_expected.to be_bad_request }
        end

        context 'if target user is a member' do
          before do
            create :user_organization, user: target_user, organization: organization
            create :user_project, user: target_user, project: project
          end

          it 'shows successful message' do
            is_expected.to redirect_to organization_project_path(organization, project)
            expect(flash[:message]).to eq(
              I18n.t('controllers.project_members.destroy.success', name: target_user.name)
            )
          end

          it 'delete from project' do
            expect { subject }.to change { target_user.projects.count }.from(1).to(0)
          end
        end

        context 'if target user is not a member' do
          it { is_expected.to be_not_found }
        end
      end
    end

    context 'when user is not an admin of the project' do
      let(:admin) { false }

      it { is_expected.to be_forbidden }
    end
  end

  describe "PATCH 'update'" do
    before do
      create :user_organization, user: user, organization: organization, admin: admin
      create :user_project, user: user, project: project, admin: admin
    end

    subject do
      patch :update, organization_id: organization.id, project_id: project.id, id: target_user_id
    end

    context 'when user is an admin of the project' do
      let(:admin) { true }

      context 'if target user is not found' do
        let(:target_user_id) { 999999 }
        it { is_expected.to be_not_found }
      end

      context 'if target user is found' do
        context 'when user is the target user' do
          let(:target_user_id) { user.id }
          it { is_expected.to be_bad_request }
        end

        context 'if target user is a member of the project' do
          before do
            create :user_organization, user: target_user, organization: organization
            create :user_project, user: target_user, project: project
          end

          it 'redirects with messeage' do
            is_expected.to redirect_to organization_project_path(organization, project)
            expect(flash[:message]).to eq(
              I18n.t('controllers.project_members.update.success', name: target_user.name)
            )
          end

          it 'grant admin to user_project' do
            expect { subject }.to change { target_user.user_projects.first.admin }.from(false).to(true)
          end
        end
      end
    end
    context 'when user is not an admin of the project' do
      let(:admin) { false }

      it { is_expected.to be_forbidden }
    end
  end

  describe "PATCH 'revoke'" do
    before do
      create :user_organization, user: user, organization: organization, admin: admin
      create :user_project, user: user, project: project, admin: admin
    end

    subject do
      patch :revoke, organization_id: organization.id, project_id: project.id, id: target_user_id
    end

    context 'when user is an admin of the organization' do
      let(:admin) { true }

      context 'if target user is not found' do
        let(:target_user_id) { 999999 }
        it { is_expected.to be_not_found }
      end

      context 'if target user is found' do
        context 'when user is the target user' do
          let(:target_user_id) { user.id }
          it { is_expected.to be_bad_request }
        end

        context 'if target user is a member of the project' do
          before do
            create :user_project, user: target_user, project: project, admin: admin
          end

          it 'redirects with messeage' do
            is_expected.to redirect_to redirect_to organization_project_path(organization, project)
            expect(flash[:message]).to eq(
              I18n.t('controllers.project_members.revoke.success', name: target_user.name)
            )
          end

          it 'revoke admin from user_project' do
            expect { subject }.to change { target_user.user_projects.first.admin }.from(true).to(false)
          end
        end
      end
    end
    context 'when user is not an admin of the project' do
      let(:admin) { false }

      it { is_expected.to be_forbidden }
    end
  end
end
