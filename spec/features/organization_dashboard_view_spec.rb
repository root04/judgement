require 'spec_helper'

describe 'View organization dashboard page' do
  subject { page }

  let!(:user) { user_sign_in }

  let(:organization) do
    create(
        :organization,
        name: 'ViewMyOrganization',
        description: 'MyDescription'
    )
  end

  before do
    create :user_organization, user: user, organization: organization, admin: true
    create :project, name: 'MyProject', organization: organization
  end

  specify 'user see an organization dashboard page' do
    visit dashboard_organization_path(organization)

    is_expected.to have_css('.organization_name', text: 'ViewMyOrganization')
    is_expected.to have_css('.list_project')
    is_expected.to have_content 'MyProject'
  end
end
