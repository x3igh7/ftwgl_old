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

    it "has a create tournament button" do
      visit admin_root_path
      expect(page).to have_content("create new tournament")
    end

    it "shows rankings" do
      visit admin_root_path
      expect(page).to have_content("set ranks")
    end

    it "shows create schedule" do
      visit admin_root_path
      expect(page).to have_content("set schedule")
    end

    it "can edit a tournament" do

    end

  end

  context "creating a tournament" do
    let!(:new_tournament) { FactoryGirl.build(:tournament) }

    before do
      admin.roles = :admin
      admin.save
      sign_in_as admin
    end

    it "has a name, description, and rules" do
      prev = Tournament.count

      visit admin_root_path
      click_on "create new tournament"

      fill_in "Name", :with => new_tournament.name
      fill_in "Description", :with => new_tournament.description
      fill_in "Rules", :with => new_tournament.rules

      click_on "Create Tournament"

      expect(Tournament.count).to eq(prev + 1)
      expect(page).to have_content(new_tournament.name)
    end

    it "shows errors with invalid criteria" do
      prev = Tournament.count
      visit admin_root_path
      click_on "create new tournament"

      click_on "Create Tournament"

      expect(Tournament.count).to eq(prev)
      expect(page).to have_content("Failed to create tournament")
    end

  end
end

def manage
  visit admin_root_path
  click_button "manage"
end
