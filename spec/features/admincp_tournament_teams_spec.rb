require 'spec_helper'

describe "admincp tournament teams" do
  let!(:tournament1) {FactoryGirl.create(:tournament)}
  let!(:tournament2) {FactoryGirl.create(:tournament, active: false)}
  let!(:admin) {FactoryGirl.create(:user)}
  let!(:team) { FactoryGirl.create(:team) }
  let!(:team2) { FactoryGirl.create(:team, name: "boo") }
  let!(:tournament_team) {FactoryGirl.create(:tournament_team, team: team, tournament: tournament1)}

  before do
    admin.roles = :admin
    admin.save
    sign_in_as(admin)
  end

  it "links tournament teams index", :js => true do
    manage
    click_link "tournament teams"
    expect(page).to have_content("[bar]")
  end

  it "allows you to edit tournament teams", :js => true do
    manage
    click_link "tournament teams"
    first(:link, "edit").click
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
    first(:link, "edit").click
    fill_in "Wins", with: "hello"
    fill_in "Losses", with: 2
    click_button "update tournament team"
    expect(current_path).to eq(edit_admin_tournament_team_path(TournamentTeam.last.id))
  end

  it "allows you to add a team to a tournament", :js => true do
    manage
    prev = TournamentTeam.count
    click_link "tournament teams"
    click_on "add tournament team"
    fill_in "Name contains", with: "boo"
    click_on "search"
    click_on "add team"
    expect(TournamentTeam.count).to eq(prev+1)
  end

  it "allows you to remove a tournament team from the tournament", :js => true do
    manage
    prev_tourny_teams = TournamentTeam.count
    click_link "tournament teams"
    first(:link, "remove").click
    expect(TournamentTeam.count).to eq(prev_tourny_teams - 1)
    expect(current_path).to eq(admin_tournament_teams_path)
  end

end

def manage
  visit admin_root_path
  click_button "manage"
end
