require 'spec_helper'

describe "Tournament Edit" do
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
    sign_in_as admin
  end

  it "a tournament can be editted", :js => true do
    manage
    click_on "edit-tourny-#{tournament1.id}"
    fill_in "Rules", with: "New rules"
    click_on "update tournament"
    expect(Tournament.find(tournament1.id).rules).to eq("New rules")
  end

  it "a tourament can be deactivated", :js => true do
    manage
    click_on "edit-tourny-#{tournament1.id}"
    click_on "deactivate tournament"
    expect(Tournament.find(tournament1.id).active).to be_false
    expect(current_path).to eq(admin_root_path)
  end

  it "deactivated (all) tournaments can be viewed" do
    visit admin_root_path
    click_on "view all tournaments"
    expect(page).to have_content(tournament2.name)
  end

  it "a non-active tournament can be activated", :js => true do
    visit admin_root_path
    click_on "view all tournaments"
    click_on "manage-tourny-#{tournament2.id}"
    click_on "edit-tourny-#{tournament2.id}"
    click_on "activate tournament"
    expect(Tournament.find(tournament2.id).active).to be_true
    expect(current_path).to eq(admin_root_path)
  end

end

def manage
  visit admin_root_path
  click_button "manage"
end
