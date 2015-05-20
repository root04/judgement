require 'spec_helper'

describe 'Account signing up' do
  subject { page }

  specify 'user sign ups account' do
    visit root_path

    click_on 'Sign up'

    fill_in 'Email', with: 'root4-signup@example.com'
    fill_in 'Name', with: 'Steve'
    fill_in 'Password', with: 'root4-signups'
    fill_in 'Password confirmation', with: 'root4-signups'

    click_on 'Sign up'

    is_expected.to have_content 'ようこそ'
    expect(find('.user_name').text).to eq 'Steve'
  end

  specify 'user sign outs' do
    user_sign_in

    is_expected.to have_content 'ようこそ'

    click_on 'Menu'
    click_on 'Sign out'

    is_expected.to have_content 'Sign in'
    is_expected.not_to have_link 'Sign out'
  end
end
