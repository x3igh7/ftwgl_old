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
      expect(page).to have_content("teams")
      expect(page).to have_content("matches")
      expect(page).to have_content("rankings")
      expect(page).to have_content("schedule")
      expect(page).to have_content("hide")
    end

    it "shows tournament teams" do
    end

    it "shows tournament matches" do
    end

    it "shows rankings" do
    end

    it "shows create schedule" do
    end

  end
end
