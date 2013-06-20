require 'spec_helper'
valid_user = build(:user)

feature "User Sign Up" do

  scenario "Guest visits site for the first time and needs to register" do

    it "Allows Guest to register with the site" do
      visit root_path
      click_on "Register"
      expect(current_root).to eq(new_user_path)
    end

    it "Does not allow Guest to register with invalid details" do
    end

  end

feature "User Sign In" do

  scenario "Guest with account wants to sign in" do

    it "Allows Guest to sign in using username and password" do
    end

    it "Does not allow Guest to sign in with invalid credentials" do
    end

  end

end

feature "User Profile" do

  scenario "A signed in user wants to view their information" do

    it "Allows User to visit their profile page" do
    end

    it "Does not allow User to visit their profile page if not signed in" do
    end

  end
end
