module UserMock
  def user_sign_in(user = nil)
    user = create(:user) unless user

    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Sign in'

    user
  end
end
