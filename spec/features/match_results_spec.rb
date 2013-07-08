require 'spec_helper'

describe "match results" do
  let!(:team_owner) { FactoryGirl.create(:user) }
  let!(:home) { FactoryGirl.create(:team) }
  let!(:member) {FactoryGirl.create(:membership, team: home, user: team_owner, role: 'owner', active: true)}
  let!(:away) { FactoryGirl.create(:team) }
  let!(:tournament) { FactoryGirl.create(:tournament) }
  let!(:team1) { FactoryGirl.create(:tournament_team, team: home, tournament: tournament) }
  let!(:team2) { FactoryGirl.create(:tournament_team, team: away, tournament: tournament) }
  let!(:match) { FactoryGirl.create(:match, home_team_id: team1.id, away_team_id: team2.id, tournament_id: tournament.id) }

  context "for users" do

    it "cannot be linked by non-team leaders" do
      user = FactoryGirl.create(:user)
      sign_in_as user
      visit tournament_match_path(tournament, match)
      expect(page).to_not have_content("Enter Results")
    end

    it "cannot be navigated to by non-team leaders" do
      user = FactoryGirl.create(:user)
      sign_in_as user
      visit edit_tournament_match_path(tournament, match)
      expect(page).to have_content("You are not authorized")
    end

  end

  context "for team owners" do
    before :each do
      sign_in_as team_owner
    end

    it "can be accessed from the match show page by team leaders" do
      visit tournament_match_path(tournament, match)
      expect(page).to have_content("Enter Results")
    end
  
    it "save with properly entered info" do
      visit tournament_match_path(tournament, match)
      click_on "Enter Results"

      fill_in "Home Team Score", with: 10
      fill_in "Away Team Score", with: 8


      click_on "Save Results"
      expect(Match.last.home_score).to eq(10)
      expect(Match.last.away_score).to eq(8)
    end
  
    it "will not save without proper info" do
      visit tournament_match_path(tournament, match)
      click_on "Enter Results"
      fill_in "Home Team Score", with: ""
      fill_in "Away Team Score", with: ""
      click_on "Save Results"
      expect(page).to have_content("Failed to update")
    end
  
    it "redirects to the match show page on successful save" do
      visit tournament_match_path(tournament, match)
      click_on "Enter Results"

      fill_in "Home Team Score", with: 10
      fill_in "Away Team Score", with: 8


      click_on "Save Results"
      expect(page).to have_content("#{home.name} vs. #{away.name}")
    end

  end

end
