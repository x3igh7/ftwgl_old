require 'spec_helper'

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
