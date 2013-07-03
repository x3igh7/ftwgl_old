require 'spec_helper'


describe "Match Creation" do
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
      visit new_tournament_match_path(tournament)
      select home.name, from: "Home"
      select away.name, from: "Away"
      fill_in "Week", with: 4
      click_on "Add New Match"
      expect(Match.count).to eq(prev + 1)
    end

    it "and adds a tournament_match for each team" do
    end

    it "and appears under matches section" do
    end

    it "and can be visited for more info" do
    end

    it "unless the two teams selected are the same" do
    end

  end
end
