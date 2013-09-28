#admincp_spec.rb
require 'spec_helper'

describe "Admin CP" do
  let!(:tournament1) {FactoryGirl.create(:tournament)}
  let!(:tournament2) {FactoryGirl.create(:tournament, active: false)}
  let!(:admin) {FactoryGirl.create(:user)}

  context "Tournament Management" do

    before do
      admin.roles = :admin
      admin.save
      sign_in_as(admin)
    end

    it "lists all active tournaments" do
      visit admin_root_path
      expect(page).to have_content(tournament1.name)
      expect(page).to_not have_content(tournament2.name)
    end

    it "has an option for editting tournament info", :js => true, :focus => true do
      visit admin_root_path
      expect(page).to have_content(tournament1.name)
      click_button "manage"
      expect(page).to have_content("edit")
      expect(page).to have_content("hide")
    end

    it "has an option for editting tournament rules" do
    end

    it "has an option for managing participating tournament teams" do
    end

    it "has an option to view all tournament matches" do
    end

    it "has an option to set rankings" do
    end

    it "has an option to create schedule" do
    end

  end
end
