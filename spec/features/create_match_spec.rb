require 'spec_helper'


describe "Match Creation", :js => true do
  let!(:admin) { FactoryGirl.create(:user) }
  let!(:home) { FactoryGirl.create(:team) }
  let!(:away) { FactoryGirl.create(:team) }
  let!(:team1) { FactoryGirl.create(:tournament_team, team: home, tournament: tournament)}
  let!(:team2) { FactoryGirl.create(:tournament_team, team: away, tournament: tournament)}
  let!(:tournament) { FactoryGirl.create(:tournament) }

  context "creates a single match within a tournament" do
    before do
      admin.roles = :admin
      admin.save
      sign_in_as admin
    end
    
    it "between two teams"do
      prev = Match.count
      create_match
      expect(Match.count).to eq(prev + 1)
    end

    it "and appears under matches section" do
      create_match
      visit tournament_path(tournament)
      #click_on "All Matches" 
      expect(page.find(".match")).to have_content(home.tag)
      expect(page.find(".match")).to have_content(away.tag)
    end

    it "can be visited for more info" do
      create_match
      expect(page).to have_content("Match")
    end
  
    it "unless the two teams selected are the same" do
      visit new_tournament_match_path(tournament)
      select home.name, from: "Home Team"
      select home.name, from: "Away Team"
      fill_in "Week", with: 4
      click_on "Add New Match"
      expect(page).to have_content("Failed to create match")
    end

  end
end

def create_match
  visit new_tournament_match_path(tournament)
  select home.name, from: "Home Team"
  select away.name, from: "Away Team"
  fill_in "Week", with: 4
  click_on "Add New Match"
end
