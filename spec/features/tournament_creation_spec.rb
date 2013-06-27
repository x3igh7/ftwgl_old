require 'spec_helper'

describe "creating a tournament" do

  context "as an admin" do
    let!(:admin) { FactoryGirl.create(:user, role: 'admin') }
    let!(:tournament) { FactoryGirl.build(:tournament) }
    
    before do
      sign_in_as admin
    end

    it "has a name, description, and rules" do
      prev = Tournament.count

      visit new_tournament_path

      fill_in "Name", :with => tournament.name
      fill_in "Description", :with => tournament.description
      fill_in "Rules", :with => tournament.rules

      click_on "Create Tournament"

      expect(Tournament.count).to eq(prev + 1)
      expect(page).to have_content(tournament.name)
    end

    it "shows errors with invalid criteria" do
      prev = Tournament.count
      visit new_tournament_path

      click_on "Create Tournament"

      expect(Tournament.count).to eq(prev)
      expect(page).to have_content("Failed to create tournament")
    end

  end
end
