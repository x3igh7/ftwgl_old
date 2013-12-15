require 'spec_helper'

describe "admincp tournament matches" do

  let!(:tournament1) {FactoryGirl.create(:tournament)}
  let!(:tournament2) {FactoryGirl.create(:tournament, active: false)}
  let!(:admin) {FactoryGirl.create(:user)}
  let!(:team) { FactoryGirl.create(:team) }
  let!(:team2) { FactoryGirl.create(:team) }
  let!(:tournament_team) {FactoryGirl.create(:tournament_team, team: team, tournament: tournament1)}
  let!(:tournament_team2) {FactoryGirl.create(:tournament_team, team: team2, tournament: tournament1)}
  let!(:match) { FactoryGirl.create(:match, home_team_id: tournament_team.id, away_team_id: tournament_team2.id, tournament_id: tournament1.id) }

  before do
    admin.roles = :admin
    admin.save
    sign_in_as(admin)
  end

  it "links to tournament matches index", :js => true do
    manage
    click_link "matches"
    expect(page).to have_content("tournament matches")
    expect(page).to have_content("week")
    expect(page).to have_content(team.name)
    expect(page).to have_content(team2.name)
  end

  it "allows admins to edit match details", :js => true do
    manage
    click_link "matches"
    click_link "edit"
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
    pending
  end

  it "allows you to remove a match", :js => true do
    manage
    prev_matches = Match.count
    click_link "matches"
    click_link "delete"
    expect(Match.count).to eq(prev_matches - 1)
  end
end

def manage
  visit admin_root_path
  click_button "manage"
end
