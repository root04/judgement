require 'spec_helper'

describe 'User edits own profile' do
  subject { page }

  specify 'user can edit name' do
    user_sign_in

    expect(find('.user_name').text).to eq 'Steve'

    click_on 'Menu'
    click_on 'Account Settings'

    within '.profiles' do
      fill_in 'Name', with: ''
      click_on '更新'
    end

    within '.profiles' do
      is_expected.to have_content 'Nameを入力してください'

      fill_in 'Name', with: 'John'
      click_on '更新'
    end

    expect(find('.user_name').text).to eq 'John'
  end
end
