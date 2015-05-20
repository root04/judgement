require 'spec_helper'

describe 'User creates a project' do
  let!(:current_user) do
    user_sign_in
  end

  let(:organization) do
    create :organization, name: 'root04'
  end

  before do
    create(
      :user_organization,
      user: current_user,
      organization: organization,
      admin: true
    )
  end

  specify 'user creates a new project' do
    click_on 'Menu'
    click_on 'Organizations'

    click_on organization.name

    click_on 'プロジェクト新規作成'

    fill_in 'Name', with: 'Oniwa'
    click_on '作成'

    expect(find('.name').text).to eq 'Oniwa'
  end

  context 'if user does not input name' do
    specify 'user see error a message' do
      click_on 'Menu'
      click_on 'Organizations'

      click_on organization.name

      click_on 'プロジェクト新規作成'
      click_on '作成'

      expect(find('.errors').text).to eq 'Nameを入力してください。'

      fill_in 'Name', with: 'Oniwa'
      click_on '作成'

      expect(find('.name').text).to eq 'Oniwa'
    end
  end
end
