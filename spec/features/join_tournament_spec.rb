require 'spec_helper'

describe 'Tournaments' do
  let!(:owner) { FactoryGirl.create(:user) }
  let!(:team) { FactoryGirl.create(:team) }
  let!(:membership) { FactoryGirl.create(:membership, team: team, user: owner, role: 'owner') }
  let!(:tournament) { FactoryGirl.create(:tournament) }

  context 'can be joined by a team' do
    before :each do
      sign_in_as owner
    end

    it 'if the team owner applies to the tournament' do
      prev = TournamentTeam.count
      join_tournament
      expect(TournamentTeam.count).to eq(prev + 1)
    end

    it 'and the team appears on the tournament rankings' do
      join_tournament
      #click_on "Rankings"
      expect(page).to have_content(team.name)
    end

    it 'but can only join the tournament once' do
      join_tournament
      page.should_not have_css("#JoinTournament")
    end
  end

  it "cannot be joined in user not signed in" do
    visit tournament_path(tournament)
    expect(page).to_not have_css("#JoinTournament")
  end
end

def join_tournament
  visit tournament_path(tournament)
  select team.name, from: "Team"
  click_on "Join tournament"
end
