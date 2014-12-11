require 'spec_helper'



describe "A User" do

  valid_user = FactoryGirl.build(:user)

  context "without an account" do

    it "can register with the site" do
      prev_user = User.count
      visit root_path
      click_on "register"
      expect(current_path).to eq(new_user_registration_path)

      within("#new_user") do #exclude the sign in form from scope
  		  fill_in "Username", :with => valid_user.username
  		  fill_in "Email", :with => valid_user.email
  		  fill_in "user_password", :with => valid_user.password
  		  fill_in "user_password_confirmation", :with => valid_user.password_confirmation
  		  click_on "Create New Account"
  		  expect(User.count).to eq(prev_user + 1)
  		  expect(User.last.email).to eq(valid_user.email)
      end
    end

    it "cannot register using invalid details" do
      prev_user = User.count
      visit root_path
      click_on "register"
      expect(current_path).to eq(new_user_registration_path)
      click_button "Create New Account"
      expect(User.count).to eq(prev_user)
    end

  end

end

describe "User" do

  let!(:registered) { FactoryGirl.create(:user) }

  context "with an account" do

    it "can sign in using their username and password" do
      visit root_path
      fill_in "Username", :with => registered.username
      fill_in "Password", :with => registered.password
      click_button "Sign in"
      expect(page).to have_content("Signed in successfully.")
    end

    it "cannot sign in with invalid credentials" do
      visit new_user_session_path
      click_button "Log In"
      expect(page).to have_content("Invalid email or password.")
    end

  end

  context "that is signed in" do

    it 'cannot link to their profile' do
      visit root_path
      expect(page).to_not have_content("User Profile")
    end

    it "can visit their profile page" do
      sign_in_as registered
      visit user_path(registered)
      expect(page).to have_content(registered.username)
    end

    it 'can choose to change password' do
      sign_in_as registered
      visit user_path(registered)
      click_on "Manage Account"
      expect(current_path).to include(edit_user_registration_path)
    end

  end
end
