require 'spec_helper'

describe 'Edit project members' do
  subject { page }

  let(:organization) { create :organization }
  let(:project) { create :project, organization: organization }
  let(:user) { user_sign_in }
  let(:target_user) { create :user, name: 'target_user', email: 'target@example.com' }
  let(:delete_target_user) { create :user, name: 'Delete_Target', email: 'delete@example.com' }
  let(:grant_admin_target_user) { create :user, name: 'Grant_Admin_Target', email: 'to_be_admin@example.com' }
  let(:revoke_admin_target_user) { create :user, name: 'Revoke_Admin_Target', email: 'revoke_admin@example.com' }

  before do
    create :user_organization, user: user, organization: organization, admin: admin
    create :user_organization, user: target_user, organization: organization, admin: admin
    create :user_project, user: user, project: project, admin: admin
  end

  context 'if user is not an admin' do
    let(:admin) { false }

    describe 'to add members' do
      specify 'user does not see form' do
        visit organization_project_path(organization, project)

        is_expected.not_to have_css '.member_add_form'
      end
    end

    describe 'to remove members' do
      specify 'user does not see remove button' do
        visit organization_project_path(organization, project)

        is_expected.not_to have_css 'input.remove_member_btn'
      end
    end

    describe 'to grant admin to members' do
      specify 'user does not see grant admin button' do
        visit organization_project_path(organization, project)

        should_not have_css 'input.grant_admin_btn'
      end
    end

    describe 'to revoke admin from members' do
      specify 'user does not see revoke admin button' do
        visit organization_project_path(organization, project)

        should_not have_css 'input.revoke_admin_btn'
      end
    end
  end

  context 'if user is an admin' do
    let(:admin) { true }

    describe 'to add members' do
      specify 'user cannot add user not belonging to the organization' do
        create :user, name: 'no_target', email: 'no_target@example.com'

        visit organization_project_path(organization, project)

        within '.member_add_form' do
          fill_in 'Email', with: 'no_target@example.com'
          click_on '追加'
        end

        is_expected.to have_content 'ユーザーが存在しません'
        expect(find('.new_member_email').value).to eq 'no_target@example.com'
      end

      specify 'user cannot add unknown user to project' do
        visit organization_project_path(organization, project)

        within '.member_add_form' do
          fill_in 'Email', with: 'test@example.com'
          click_on '追加'
        end

        is_expected.to have_content 'ユーザーが存在しません'
        expect(find('.new_member_email').value).to eq 'test@example.com'
      end

      specify 'user can add a member to project' do
        visit organization_project_path(organization, project)

        within '.member_add_form' do
          fill_in 'Email', with: 'target@example.com'
          click_on '追加'
        end

        is_expected.to have_content 'target_userを追加しました'
        expect(find('.new_member_email').value).to be_blank

        expect(all('.member').size).to eq 2
        expect(all('.member').first.text).to eq user.name
        expect(all('.member').last.text).to eq 'target_user'
      end
    end

    describe 'to remove members' do
      specify 'user does not see remove button for self removement' do
        visit organization_project_path(organization, project)

        within('.list-group-item') do
          is_expected.not_to have_button '削除'
        end
      end

      specify 'user can remove a member' do
        create :user_organization, user: delete_target_user, organization: organization
        create :user_project, user: delete_target_user, project: project
        visit organization_project_path(organization, project)

        within(find('.list-group-item', text: delete_target_user.name)) do
          click_on '削除'
        end

        is_expected.to have_content 'Delete_Targetを削除しました'
        expect(find('.new_member_email').value).to be_blank

        expect(all('.member').size).to eq 1
        expect(all('.member').first.text).to eq user.name
      end
    end
    describe 'to grant admin to members' do
      specify 'user does not see grant admin button for self' do
        visit organization_project_path(organization, project)

        within('.list-group-item') do
          should_not have_button '管理者付与'
        end
      end

      specify 'user can grant admin to a member' do
        create :user_organization, user: grant_admin_target_user, organization: organization
        create :user_project, user: grant_admin_target_user, project: project, admin: 'false'
        visit organization_project_path(organization, project)

        within(find('.list-group-item', text: grant_admin_target_user.name)) do
          click_on '管理者付与'
        end

        should have_content 'Grant_Admin_Targetに管理者権限を付与しました'
        expect(find('.new_member_email').value).to be_blank
        expect(all('.member').size).to eq 2
        user_names = all('.member').map(&:text)
        expect(user_names).to include user.name
        expect(user_names).to include 'Grant_Admin_Target'
        within(find('.list-group-item', text: grant_admin_target_user.name)) do
          should_not have_button '管理者付与'
        end
      end
    end
    describe 'to revoke admin from members' do
      specify 'user does not see revoke admin button for self' do
        visit organization_project_path(organization, project)

        within('.list-group-item') do
          should_not have_button '管理者剥奪'
        end
      end

      specify 'user can revoke admin from a member' do
        create :user_organization, user: revoke_admin_target_user, organization: organization
        create :user_project, user: revoke_admin_target_user, project: project, admin: 'true'
        visit organization_project_path(organization, project)

        within(find('.list-group-item', text: revoke_admin_target_user.name)) do
          click_on '管理者剥奪'
        end

        should have_content 'Revoke_Admin_Targetから管理者権限を剥奪しました'
        expect(find('.new_member_email').value).to be_blank
        expect(all('.member').size).to eq 2
        user_names = all('.member').map(&:text)
        expect(user_names).to include user.name
        expect(user_names).to include 'Revoke_Admin_Target'
        within(find('.list-group-item', text: revoke_admin_target_user.name)) do
          should_not have_button '管理者剥奪'
        end
      end
    end
  end
end
