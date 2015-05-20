require 'spec_helper'

describe 'Organization Search' do
  subject { page }

  specify 'user see search result' do
    user_sign_in
    visit search_organizations_path

    fill_in 'keyword', with: ''
    click_on 'Search'
    is_expected.to have_content '該当する項目はありません'
  end
end
