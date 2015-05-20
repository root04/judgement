require 'spec_helper'

describe UsersController do
  let(:user) { create :user }

  before do
    sign_in user
  end

  describe "GET 'edit'" do
    subject { get :edit }

    it { is_expected.to be_success }
  end

  describe "PATCH 'update'" do
    subject { patch :update, user: params }

    let(:params) do
      { name: 'John' }
    end

    it { is_expected.to redirect_to edit_user_path(user) }

    it 'updates user name' do
      expect { subject }.to change {
        user.reload.name
      }.from('Steve').to('John')
    end

    context 'if invalid name is given' do
      let(:params) do
        { name: '' }
      end

      it 'render edit with error messages' do
        is_expected.to render_template 'edit'
        expect(assigns(:errors).size).to eq 2
      end
    end
  end
end
