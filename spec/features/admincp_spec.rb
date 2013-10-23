#admincp_spec.rb
require 'spec_helper'

describe "Admin CP" do
  let!(:tournament1) {FactoryGirl.create(:tournament)}
  let!(:tournament2) {FactoryGirl.create(:tournament, active: false)}
  let!(:admin) {FactoryGirl.create(:user)}
  let!(:team) { FactoryGirl.create(:team) }
  let!(:tournament_team) {FactoryGirl.create(:tournament_team, team: team, tournament: tournament1)}

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
      it "links tournament teams index", :js => true, :focus => true do
        manage
        click_link "tournament teams"
        expect(page).to have_content("[bar]")
      end

      it "allows you to edit tournament teams" do
        visit admin_root_path
        click_button "manage"
      end

      it "allows you to add a tournament team" do
      end

      it "allows you to remove a tournament team from the tournament" do
      end

    end

    it "shows tournament matches" do
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
