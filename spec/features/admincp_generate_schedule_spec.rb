require 'spec_helper'
DatabaseCleaner.clean

describe "generate schedule" do

  let!(:tournament1) {FactoryGirl.create(:tournament)}
  let!(:tournament2) {FactoryGirl.create(:tournament, active: false)}
  let!(:admin) {FactoryGirl.create(:user)}
  let!(:team) { FactoryGirl.create(:team) }
  let!(:team2) { FactoryGirl.create(:team) }
  let!(:team3) { FactoryGirl.create(:team) }
  let!(:team4) { FactoryGirl.create(:team) }
  let!(:team5) { FactoryGirl.create(:team) }
  let!(:team6) { FactoryGirl.create(:team) }
  let!(:tournament_team) {FactoryGirl.create(:tournament_team, team: team, tournament: tournament1, rank: 6)}
  let!(:tournament_team2) {FactoryGirl.create(:tournament_team, team: team2, tournament: tournament1, rank: 5)}
  let!(:tournament_team3) {FactoryGirl.create(:tournament_team, team: team3, tournament: tournament1, rank: 4)}
  let!(:tournament_team4) {FactoryGirl.create(:tournament_team, team: team4, tournament: tournament1, rank: 3)}
  let!(:tournament_team5) {FactoryGirl.create(:tournament_team, team: team5, tournament: tournament1, rank: 2)}
  let!(:tournament_team6) {FactoryGirl.create(:tournament_team, team: team6, tournament: tournament1, rank: 1)}
  let!(:match) { FactoryGirl.create(:match, home_team_id: tournament_team.id, away_team_id: tournament_team2.id, tournament_id: tournament1.id) }

  before do
    admin.roles = :admin
    admin.save
    sign_in_as(admin)
  end

  it "is linked to from the cpanel", :js => true do
    manage
    click_link "set schedule"
    expect(page).to have_content("set schedule")
    expect(page).to have_content("week")
    expect(page).to have_content("date")
  end

  it "generates matches based on rank and previous matchups", :js => true do
    manage
    click_link "set schedule"
    expect(page).to have_select("#{tournament_team6.id}", selected: tournament_team6.team.name)
    expect(page).to have_select("#{tournament_team5.id}", selected: tournament_team5.team.name)
  end

  it "saves generated matches", :js => true do
    prev = Match.all.count
    manage
    click_link "set schedule"
    click_on "create matches"
    expect(Match.all.count).to eq(prev+3)
    expect(page).to have_content("matches successfully created!")
    tournament_with_week = Tournament.find(tournament1.id)
    expect(tournament_with_week.current_week_num).to eq(1)
  end


end

def manage
  visit admin_root_path
  find('#manage-tournaments').click
end
