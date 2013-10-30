require 'spec_helper'

describe "AdminCP Match Creation" do
  let!(:admin) { FactoryGirl.create(:user) }
  let!(:home) { FactoryGirl.create(:team) }
  let!(:away) { FactoryGirl.create(:team) }
  let!(:team1) { FactoryGirl.create(:tournament_team, team: home, tournament: tournament)}
  let!(:team2) { FactoryGirl.create(:tournament_team, team: away, tournament: tournament)}
  let!(:tournament) { FactoryGirl.create(:tournament) }

  before do
    admin.roles = :admin
    admin.save
    sign_in_as(admin)
  end


  it "between two teams", :js => true do
    manage
    click_link "matches"
    click_on "create match"
    prev = Match.count
    create_match
    expect(Match.count).to eq(prev + 1)
  end

  it "and appears under matches section", :js => true do
    manage
    click_link "matches"
    click_on "create match"
    create_match
    visit admin_matches_path(:tournament_id => tournament.id)
    expect(page).to have_content(home.tag)
    expect(page).to have_content(away.tag)
  end

  it "can be visited for more info", :js => true do
    manage
    click_link "matches"
    click_on "create match"
    create_match
    visit admin_root_path
    click_button "manage"
    click_link "matches"
    click_link "show"
    expect(page).to have_content("#{home.name} vs. #{away.name}")
  end

  it "unless the two teams selected are the same", :js => true do
    manage
    click_link "matches"
    click_on "create match"
    select home.name, from: "home team"
    select home.name, from: "away team"
    fill_in "Week", with: 4
    click_on "Add New Match"
    expect(page).to have_content("Failed to create match")
  end

end

def create_match
  select home.name, from: "home team"
  select away.name, from: "away team"
  fill_in "Week", with: 4
  click_on "Add New Match"
end

def manage
  visit admin_root_path
  click_button "manage"
end
