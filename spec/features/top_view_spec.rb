require 'spec_helper'

describe 'Top page view' do
  subject { page }

  before do
    user_sign_in
  end

  it 'show welcome message' do
    visit root_path

    is_expected.to have_content 'ようこそ'
  end
end
