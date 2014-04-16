require 'spec_helper'

describe "Playoffs creation" do
  let!(:admin) {FactoryGirl.create(:user) }
  let!(:tournament1) {FactoryGirl.create(:tournament)}
  let!(:team) { FactoryGirl.create(:team) }
  let!(:team2) { FactoryGirl.create(:team) }
  let!(:tournament_team) {FactoryGirl.create(:tournament_team, team: team, tournament: tournament1)}
  let!(:tournament_team2) {FactoryGirl.create(:tournament_team, team: team2, tournament: tournament1)}

  before do
    admin.roles = :admin
    admin.save
    sign_in_as(admin)
  end

  it 'creates playoff bracket for a season tournament', :js => true, :focus => true do
    manage
    click_on 'start playoffs'
    expect(page).to have_content('generate playoff bracket')
    fill_in "bracket size", with: 2
    click_on 'show playoff teams'
    expect(page).to have_content(team.name)
    expect(page).to have_content(team2.name)
    click_on 'create'
    playoff_tournament = Tournament.find(tournament.id)
    expect(playoff_tournament.bracket_size).to eq(2)
    expect(playoff_tournament.matches.length).to eq(1)
    expect(playoff_tournament.playoffs).to be_true
  end

end

def manage
  visit admin_root_path
  click_button "manage"
end
