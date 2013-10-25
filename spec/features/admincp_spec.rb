#admincp_spec.rb
require 'spec_helper'

describe "Admin CP" do
  let!(:tournament1) {FactoryGirl.create(:tournament)}
  let!(:tournament2) {FactoryGirl.create(:tournament, active: false)}
  let!(:admin) {FactoryGirl.create(:user)}
  let!(:team) { FactoryGirl.create(:team) }
  let!(:team2) { FactoryGirl.create(:team) }
  let!(:tournament_team) {FactoryGirl.create(:tournament_team, team: team, tournament: tournament1)}
  let!(:tournament_team2) {FactoryGirl.create(:tournament_team, team: team2, tournament: tournament1)}
  let!(:match) { FactoryGirl.create(:match, home_team_id: tournament_team.id, away_team_id: tournament_team2.id, tournament_id: tournament1.id) }

  it "cannot access admincp if not admin" do
    visit admin_root_path
    expect(current_path).to eq(root_path)
  end

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

    context "edit tournament" do
      it "has an option for editting tournament info", :js => true do
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

      it "links to tournament edit", :js => true do
        manage
        click_link "edit"
        expect(page).to have_content("edit tournament")
        expect(page).to have_button("update tournament")
      end

      it "successfully updates a tournament", :js => true do
        manage
        click_link "edit"
        fill_in "Name", with: "FTW Killfest 3"
        click_button "update tournament"
        expect(current_path).to eq(admin_root_path)
        expect(page).to have_content("FTW Killfest 3")
      end
    end

    context "tournament teams" do
      it "links tournament teams index", :js => true do
        manage
        click_link "tournament teams"
        expect(page).to have_content("[bar]")
      end

      it "allows you to edit tournament teams", :js => true do
        manage
        click_link "tournament teams"
        click_link "edit"
        fill_in "Wins", with: 3
        fill_in "Losses", with: 2
        click_button "update tournament team"
        expect(current_path).to eq(admin_tournament_teams_path)
        expect(TournamentTeam.last.wins).to eq(3)
        expect(TournamentTeam.last.losses).to eq(2)
      end

      it "redirects back to edit page with bad inputs", :js => true do
        manage
        click_link "tournament teams"
        click_link "edit"
        fill_in "Wins", with: "hello"
        fill_in "Losses", with: 2
        click_button "update tournament team"
        expect(current_path).to eq(edit_admin_tournament_team_path(team.id))
      end

      it "allows you to add a tournament team" do
      end

      it "allows you to remove a tournament team from the tournament", :js => true do
        manage
        prev_tourny_teams = TournamentTeam.count
        click_link "tournament teams"
        click_link "delete"
        expect(TournamentTeam.count).to eq(prev_tourny_teams - 1)
        expect(current_path).to eq(admin_tournament_teams_path)
      end

    end

    context "shows tournament matches" do
      it "links to tournament matches index", :js => true do
        manage
        click_link "matches"
        expect(page).to have_content("tournament matches")
        expect(page).to have_content("week")
        expect(page).to have_content("foo2 [bar]")
      end

      it "allows admins to edit match details", :js => true do
        manage
        click_link "matches"
        click_link "edit"
        save_and_open_page
        fill_in "Home score", with: 5
        fill_in "Away score", with: 4
        fill_in "Week", with: 2
        click_button "update tournament match"
        expect(current_path).to eq(admin_matches_path)
        click_link "edit"
        edit_match = Match.last
        expect(edit_match.home_score).to eq(5)
        expect(edit_match.away_score).to eq(4)
        expect(edit_match.week_num).to eq(2)
      end

      it "doesn't allow edit with bad details", :js => true do
        manage
        click_link "matches"
        click_link "edit"
        fill_in "Home score", with: "abc"
        fill_in "Away score", with: 4
        click_button "update tournament match"
        expect(current_path).to eq(edit_admin_match_path(match))
      end

      it "properly adjusts the results when updating a match" do
      end

      it "allows you to remove a match", :js => true do
        manage
        prev_matches = Match.count
        click_link "matches"
        click_link "delete"
        expect(Match.count).to eq(prev_matches - 1)
      end
    end

    it "shows rankings" do
    end

    it "shows create schedule" do
    end

  end
end

def manage
  visit admin_root_path
  click_button "manage"
end
