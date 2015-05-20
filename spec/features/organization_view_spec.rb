require 'spec_helper'

describe 'View organization public page' do
  subject { page }
  let!(:user) { user_sign_in }
  let(:mail_to_organization) { create :organization }
  let(:organization) do
    create(
        :organization,
        name: 'ViewMyOrganization',
        description: 'MyDescription'
    )
  end
  let(:admin) { true }
  before do
    create :user_organization, user: user, organization: organization, admin: admin
  end

  specify 'user see an organization detail page' do
    visit organization_path(organization)
    is_expected.to have_css('.dashboard', text: 'Dashboard')
    is_expected.to have_content 'ViewMyOrganization'
    is_expected.to have_content 'MyDescription'
  end

  context 'if organization does not have description' do
    before do
      organization.update_column(:description, nil)
    end

    specify 'description is not shown' do
      visit organization_path(organization)
      is_expected.to have_content 'ViewMyOrganization'
    end
  end

  context 'if user is not a member of any organizations' do
    before do
      organization.destroy
    end

    specify 'user does not see contact form' do
      visit organization_path(mail_to_organization)

      is_expected.not_to have_css('.form-control')
    end
  end
end
