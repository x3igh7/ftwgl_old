require 'spec_helper'


describe "Match Creation" do
  context "creates a single match within a tournament" do
    
    it "between two teams" do
      prev = TournamentMatch.count
      sign_in_as :admin
      visit tournament_new_match_path(tournament)
      select team1.name, from: "Home"
      select team2.name, from: "Away"
      click_on "Add New Match"
      expect(TournamentMatch.count).to eq(prev + 1)
    end

    it "and appears under matches section" do
    end

    it "and can be visited for more info" do
    end

  end
end
