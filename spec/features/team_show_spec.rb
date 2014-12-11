require 'spec_helper'

describe "index" do
  let!(:owner) { FactoryGirl.create(:user) }
  let!(:team) { FactoryGirl.create(:team) }
  let!(:team2) { FactoryGirl.create(:team) }
  let!(:membership) { FactoryGirl.create(:membership, team: team, user: owner, role: 'owner') }
  let!(:tournament) { FactoryGirl.create(:tournament) }
  let!(:tournament_team) { FactoryGirl.create(:tournament_team, team: team, tournament: tournament, wins: 15, losses: 5) }
  let!(:tournament_team2) { FactoryGirl.create(:tournament_team, team: team2, tournament: tournament, wins: 15, losses: 5) }

  it "searchable teams" do
    visit teams_path
    fill_in "q_name_cont", with: team.name
    click_on "search"
    expect(page).to have_content(team.name)
    expect(page).to_not have_content(team2.name)
  end

  it "returns no results for non-exisiting team" do
    visit teams_path
    fill_in "q_name_cont", with: 'Random'
    click_on "search"
    expect(page).to have_content("No results found")
  end

end

describe "show" do
  let!(:owner) { FactoryGirl.create(:user) }
  let!(:team) { FactoryGirl.create(:team) }
  let!(:membership) { FactoryGirl.create(:membership, team: team, user: owner, role: 'owner') }
  let!(:tournament) { FactoryGirl.create(:tournament) }
  let!(:tournament_team) { FactoryGirl.create(:tournament_team, team: team, tournament: tournament, wins: 15, losses: 5) }

  context "team stats" do
    before do
      sign_in_as owner
    end

    it "calculates total wins" do
      visit team_path(team)
      expect(page.find("#wins_count")).to have_content(15)
    end

    it "calculates total losses" do
      visit team_path(team)
      expect(page.find("#losses_count")).to have_content(5)
    end

    it "calculated win perc" do
      visit team_path(team)
      expect(page.find("#winning_perc")).to have_content("75.0%")
    end

  end

  context "Team roster" do
    it "can change membership status" do
      pending
    end

    it "can change member role" do
      pending
    end
  end
end
