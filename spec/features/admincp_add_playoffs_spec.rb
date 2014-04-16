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
    expect(current_page).to have_content('Generate Playoff Bracket')
  end

end

def manage
  visit admin_root_path
  click_button "manage"
end
