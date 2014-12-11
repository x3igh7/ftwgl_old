require 'spec_helper'

describe "admincp tournament rankings" do

  let!(:tournament1) {FactoryGirl.create(:tournament)}
  let!(:tournament2) {FactoryGirl.create(:tournament, active: false)}
  let!(:admin) {FactoryGirl.create(:user)}
  let!(:team) { FactoryGirl.create(:team) }
  let!(:team2) { FactoryGirl.create(:team) }
  let!(:tournament_team) {FactoryGirl.create(:tournament_team, team: team, tournament: tournament1, total_points: 9)}
  let!(:tournament_team2) {FactoryGirl.create(:tournament_team, team: team2, tournament: tournament1, total_points: 6)}
  let!(:match) { FactoryGirl.create(:match, home_team_id: tournament_team.id, away_team_id: tournament_team2.id, tournament_id: tournament1.id) }

  before do
    admin.roles = :admin
    admin.save
    sign_in_as(admin)
  end

  it "links to ranks edit page for tournament", :js => true do
    visit admin_root_path
    manage
    click_link "set ranks"
    expect(page).to have_content("set ranks")
    expect(page).to have_content(team.name)
    expect(page).to have_content(team2.name)
  end

  it "updates all the ranks", :js => true do
    visit admin_root_path
    manage
    click_link "set ranks"
    click_button "update"
    edit_rank = TournamentTeam.last
    expect(page).to have_content("ranks successfully updated")
    expect(edit_rank.rank).to eq(2)
  end

end


def manage
  visit admin_root_path
  find('#manage-tournaments').click
end
