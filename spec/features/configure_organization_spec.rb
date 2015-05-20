require 'spec_helper'

describe 'User configures organizations' do
  let!(:user) { user_sign_in }

  subject { page }

  context 'when user has no organizations' do
    specify 'user can create new organization' do
      visit root_path

      click_on 'Menu'
      click_on 'Organizations'

      within '.organizations' do
        expect(all('.organization').size).to eq 0
      end

      click_on '新規作成'

      fill_in 'Name', with: 'root04'
      click_on '作成'

      expect(find('.organization_name').text).to eq 'root04'
      expect(all('.member').size).to eq 1
      expect(find('.member').text).to eq user.name

      click_on 'Menu'
      click_on 'Organizations'

      within '.organizations' do
        expect(all('.organization').size).to eq 1
        is_expected.to have_link(
          'root04',
          href: dashboard_organization_path(Organization.of('root04').first)
        )
      end
    end

    it 'validates invalid input' do
      visit root_path

      click_on 'Menu'
      click_on 'Organizations'
      click_on '新規作成'

      fill_in 'Name', with: ''
      click_on '作成'

      expect(all('.error').size).to eq 2
    end
  end
end
