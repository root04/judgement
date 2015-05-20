require 'spec_helper'

describe OrganizationMembersController do
  let(:user) { create :user }

  before do
    sign_in user
  end

  describe "POST 'create'" do
    subject do
      post :create, organization_id: organization.id, email: 'test@example.com'
    end

    let(:organization) { create :organization }

    before do
      create :user_organization, user: user, organization: organization, admin: admin
    end

    context 'when user is an admin of the organization' do
      let(:admin) { true }

      context 'if target user is not found' do
        it 'redirects with error' do
          is_expected.to redirect_to dashboard_organization_path(organization)
          expect(flash[:email]).to eq 'test@example.com'
          expect(flash[:error]).to eq(
            I18n.t('controllers.organization_members.create.user_not_found')
          )
        end
      end

      context 'if target user is found' do
        let!(:target_user) { create :user, email: 'test@example.com' }

        context 'who is already a member' do
          before do
            create :user_organization, user: target_user, organization: organization
          end

          it 'redirects without messeage' do
            is_expected.to redirect_to dashboard_organization_path(organization)
            expect(flash[:email]).to be_nil
            expect(flash[:error]).to be_nil
          end

          it 'does not create new association' do
            expect { subject }.to_not change { UserOrganization.count }.from(2)
          end
        end

        context 'who is not a member' do
          it 'redirects with messeage' do
            is_expected.to redirect_to dashboard_organization_path(organization)
            expect(flash[:email]).to be_nil
            expect(flash[:message]).to eq(
              I18n.t('controllers.organization_members.create.success', name: target_user.name)
            )
          end

          it 'creates new association' do
            expect { subject }.to change { UserOrganization.count }.from(1).to(2)
            expect(target_user).to be_member_of(organization)
            expect(target_user).to_not be_configurable(organization)
          end
        end
      end
    end

    context 'when user is not an admin of the organization' do
      let(:admin) { false }

      it { is_expected.to be_forbidden }
    end
  end

  describe "DELETE 'destroy'" do
    let(:organization) { create :organization }

    before do
      create :user_organization, user: user, organization: organization, admin: admin
    end

    subject do
      delete :destroy, organization_id: organization.id, id: target_user_id
    end
    let(:target_user) { create :user, name: 'Steve', email: 'test@example.com' }
    let(:target_user_id) { target_user.id }

    context 'when user is an admin of the organization' do
      let(:admin) { true }

      context 'if target user is not found' do
        let(:target_user_id) { 999999 }
        it 'redirects with error' do
          expect(subject.status).to eq(404)
          expect(flash[:email]).to be_nil
          expect(flash[:error]).to be_nil
        end
      end

      context 'if target user is found' do
        context 'when user is the target user' do
          let(:target_user_id) { user.id }

          it 'redirects with error' do
            expect(subject.status).to eq(400)
            expect(flash[:email]).to be_nil
            expect(flash[:error]).to be_nil
          end
        end

        context 'who is a member' do
          before do
            create :user_organization, user: target_user, organization: organization, admin: admin
          end

          it 'redirects with messeage' do
            is_expected.to redirect_to dashboard_organization_path(organization)
            expect(flash[:email]).to be_nil
            expect(flash[:message]).to eq(
              I18n.t('controllers.organization_members.destroy.success', name: target_user.name)
            )
          end

          it 'delete from organization' do
            expect { subject }.to change { target_user.organizations.count }.from(1).to(0)
          end
        end

        context 'who is not a member' do
          it 'returns response code 404' do
            expect(subject.status).to eq(404)
            expect(flash[:email]).to be_nil
            expect(flash[:error]).to be_nil
          end
        end
      end
    end

    context 'when user is not an admin of the organization' do
      let(:admin) { false }

      it { is_expected.to be_forbidden }
    end
  end
  describe "PATCH 'update'" do
    let(:organization) { create :organization }

    before do
      create :user_organization, user: user, organization: organization, admin: admin
    end

    subject do
      put :update, organization_id: organization.id, id: target_user_id
    end

    let(:target_user) { create :user }
    let(:target_user_id) { target_user.id }

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

        context 'who is a member' do
          before do
            create :user_organization, user: target_user, organization: organization
          end

          it 'redirects with messeage' do
            is_expected.to redirect_to dashboard_organization_path(organization)
            expect(flash[:message]).to eq(
              I18n.t('controllers.organization_members.update.success', name: target_user.name)
            )
          end

          it 'grant admin to user_organization' do
            expect { subject }.to change { target_user.user_organizations.first.admin }.from(false).to(true)
          end
        end
      end
    end
    context 'when user is not an admin of the organization' do
      let(:admin) { false }

      it { is_expected.to be_forbidden }
    end
  end

  describe "PATCH 'revoke'" do
    let(:organization) { create :organization }

    before do
      create :user_organization, user: user, organization: organization, admin: admin
    end

    subject do
      patch :revoke, organization_id: organization.id, id: target_user_id
    end

    let(:target_user) { create :user }
    let(:target_user_id) { target_user.id }

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

        context 'who is a member' do
          before do
            create :user_organization, user: target_user, organization: organization, admin: admin
          end

          it 'redirects with messeage' do
            is_expected.to redirect_to dashboard_organization_path(organization)
            expect(flash[:message]).to eq(
              I18n.t('controllers.organization_members.revoke.success', name: target_user.name)
            )
          end

          it 'revoke admin from user_organization' do
            expect { subject }.to change { target_user.user_organizations.first.admin }.from(true).to(false)
          end
        end
      end
    end
    context 'when user is not an admin of the organization' do
      let(:admin) { false }

      it { is_expected.to be_forbidden }
    end
  end
end
