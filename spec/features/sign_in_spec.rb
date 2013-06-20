require 'spec_helper'
valid_user = FactoryGirl.build(:user)

describe "User Sign Up" do

  context "Guest visits site for the first time and needs to register" do

    it "Allows Guest to register with the site" do
      prev_user = User.count
      visit root_path
      click_on "Register"
      expect(current_path).to eq(new_user_registration_path)
      fill_in "Username", :with => valid_user.username
      fill_in "Email", :with => valid_user.email
      fill_in "user_password", :with => valid_user.password
      fill_in "user_password_confirmation", :with => valid_user.password_confirmation
      click_on "Create New Account"
      expect(User.count).to eq(prev_user + 1)
      expect(User.last.email).to eq(valid_user.email)
    end

    it "Does not allow Guest to register with invalid details" do
      prev_user = User.count
      visit root_path
      click_on "Register"
      expect(current_path).to eq(new_user_registration_path)
      click_button "Create New Account"
      expect(User.count).to eq(prev_user)
    end

  end

end

describe "User Sign In" do

  context "Guest with account wants to sign in" do

    it "Allows Guest to sign in using username and password" do
    end

    it "Does not allow Guest to sign in with invalid credentials" do
    end

  end

end

describe "User Profile" do

  context "A signed in user wants to view their information" do

    it "Allows User to visit their profile page" do
    end

    it "Does not allow User to visit their profile page if not signed in" do
    end

  end
end
