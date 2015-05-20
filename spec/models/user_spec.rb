require 'spec_helper'

describe User do
  describe '#configurable?' do
    subject { user.configurable?(organization) }

    let(:user) { create :user }
    let(:organization) { create :organization }

    context 'if user is not a member of the organization' do
      it { is_expected.to eq false }
    end

    context 'if user is a member of the organization' do
      before do
        create :user_organization, user: user, organization: organization, admin: admin
      end

      context 'who is an admin' do
        let(:admin) { true }

        it { is_expected.to eq true }
      end

      context 'who is not an admin' do
        let(:admin) { false }

        it { is_expected.to eq false }
      end
    end
  end

  describe '#create_organization' do
    subject { user.create_organization(name) }
    let(:user) { create :user }

    context 'if valid name is given' do
      let(:name) { 'Valid Name' }

      it 'creates organization' do
        expect {
          expect { subject }.to change { Organization.count }.from(0).to(1)
        }.to change { UserOrganization.count }.from(0).to(1)

        expect(subject.users).to eq [user]
        expect(user).to be_configurable(subject)
      end
    end

    context 'if invalid name is given' do
      let(:name) { '' }

      it 'does not create record' do
        expect {
          expect { subject }.to_not change { Organization.count }.from(0)
        }.to_not change { UserOrganization.count }.from(0)

        expect(subject).to_not be_persisted
      end
    end
  end
end
