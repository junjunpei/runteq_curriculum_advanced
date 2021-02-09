module LoginMacros
  def login_as(user)
    visit admin_login_identifier_path
    fill_in 'user_name', with: user.name
    click_button '次へ'
    fill_in 'user_password', with: 'password'
    click_button 'ログイン'
  end
end
