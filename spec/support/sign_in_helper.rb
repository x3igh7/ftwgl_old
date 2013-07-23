module SignIn

  def sign_in_as(user)
      visit root_path
      fill_in "Username", with: user.username
      fill_in "Password", with: user.password
      click_button "Sign in"
  end

end
