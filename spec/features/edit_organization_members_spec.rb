require 'spec_helper'

describe 'Edit organization members' do
  subject { page }

  let(:organization) { create :organization }
  let(:user) { user_sign_in }
  let(:delete_target_user) { create :user, name: 'Delete_Target', email: 'delete@example.com' }
  let(:grant_admin_target_user) { create :user, name: 'Grant_Admin_Target', email: 'to_be_admin@example.com' }
  let(:revoke_admin_target_user) { create :user, name: 'Revoke_Admin_Target', email: 'revoke_admin@example.com' }

  before do
    create :user_organization, user: user, organization: organization, admin: admin
  end

  context 'if user is not an admin' do
    let(:admin) { false }

    describe 'to add members' do
      specify 'user does not see form' do
        visit dashboard_organization_path(organization)

        is_expected.not_to have_css '.member_add_form'
      end
    end

    describe 'to remove members' do
      specify 'user does not see remove button' do
        visit dashboard_organization_path(organization)

        is_expected.not_to have_css 'input.remove_member_btn'
      end
    end

    describe 'to grant admin to members' do
      specify 'user does not see grant admin button' do
        visit organization_path(organization)

        should_not have_css 'input.grant_admin_btn'
      end
    end

    describe 'to revoke admin from members' do
      specify 'user does not see revoke admin button' do
        visit organization_path(organization)

        should_not have_css 'input.revoke_admin_btn'
      end
    end
  end

  context 'if user is an admin' do
    let(:admin) { true }

    describe 'to add members' do
      specify 'user cannot add unknown user' do
        visit dashboard_organization_path(organization)

        within '.member_add_form' do
          fill_in 'Email', with: 'test@example.com'
          click_on '追加'
        end

        is_expected.to have_content 'ユーザーが存在しません'
        expect(find('.new_member_email').value).to eq 'test@example.com'
      end

      specify 'user can add a member' do
        create :user, email: 'test@example.com', name: 'Bob'

        visit dashboard_organization_path(organization)

        within '.member_add_form' do
          fill_in 'Email', with: 'test@example.com'
          click_on '追加'
        end

        is_expected.to have_content 'Bobを追加しました'
        expect(find('.new_member_email').value).to be_blank

        expect(all('.member').size).to eq 2
        should have_css '.member', text: user.name
        should have_css '.member', text: 'Bob'
      end
    end

    describe 'to remove members' do
      specify 'user does not see remove button for self removement' do
        visit dashboard_organization_path(organization)

        within('.list-group-item') do
          is_expected.not_to have_button '削除'
        end
      end

      specify 'user can remove a member' do
        create :user_organization, user: delete_target_user, organization: organization, admin: admin
        visit dashboard_organization_path(organization)

        within(find('.list-group-item', text: delete_target_user.name)) do
          click_on '削除'
        end

        is_expected.to have_content 'Delete_Targetを削除しました'
        expect(find('.new_member_email').value).to be_blank

        expect(all('.member').size).to eq 1
        should have_css '.member', text: user.name
      end
    end

    describe 'to grant admin to members' do
      specify 'user does not see grant admin button for self' do
        visit dashboard_organization_path(organization)

        within('.list-group-item') do
          should_not have_button '管理者付与'
        end
      end

      specify 'user can grant admin to a member' do
        create :user_organization, user: grant_admin_target_user, organization: organization, admin: 'false'
        visit dashboard_organization_path(organization)

        within(find('.list-group-item', text: grant_admin_target_user.name)) do
          click_on '管理者付与'
        end

        should have_content 'Grant_Admin_Targetに管理者権限を付与しました'
        expect(find('.new_member_email').value).to be_blank
        expect(all('.member').size).to eq 2
        should have_css '.member', text: user.name
        should have_css '.member', text: 'Grant_Admin_Target'
        within(find('.list-group-item', text: grant_admin_target_user.name)) do
          should_not have_button '管理者付与'
        end
      end
    end

    describe 'to revoke admin from members' do
      specify 'user does not see revoke admin button for self' do
        visit dashboard_organization_path(organization)

        within('.list-group-item') do
          should_not have_button '管理者剥奪'
        end
      end

      specify 'user can revoke admin from a member' do
        create :user_organization, user: revoke_admin_target_user, organization: organization, admin: 'true'
        visit dashboard_organization_path(organization)

        within(find('.list-group-item', text: revoke_admin_target_user.name)) do
          click_on '管理者剥奪'
        end

        should have_content 'Revoke_Admin_Targetから管理者権限を剥奪しました'
        expect(find('.new_member_email').value).to be_blank
        expect(all('.member').size).to eq 2
        should have_css '.member', text: user.name
        should have_css '.member', text: 'Revoke_Admin_Target'
        within(find('.list-group-item', text: revoke_admin_target_user.name)) do
          should_not have_button '管理者剥奪'
        end
      end
    end
  end
end
