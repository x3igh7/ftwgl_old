require 'spec_helper'

describe TournamentTeam do
  it { should validate_presence_of(:team) }
  it { should validate_presence_of(:tournament) }
  it { should validate_presence_of(:total_points) }
  it { should validate_presence_of(:total_diff) }
  it { should belong_to(:team) }
  it { should belong_to(:tournament) }

  describe "should have 1 membership per team per tournament" do
    team = FactoryGirl.build(:team)
    tournament = FactoryGirl.build(:tournament)
    before do
      FactoryGirl.create(:tournament_team, team: team, tournament: tournament)
    end
  
    it { should validate_uniqueness_of(:team_id) }
  end

  describe "update tourny scores" do
    let!(:team_owner) { FactoryGirl.create(:user) }
    let!(:home) { FactoryGirl.create(:team) }
    let!(:member) {FactoryGirl.create(:membership, team: home, user: team_owner, role: 'owner', active: true)}
    let!(:away) { FactoryGirl.create(:team) }
    let!(:tournament) { FactoryGirl.create(:tournament) }
    let!(:team1) { FactoryGirl.create(:tournament_team, team: home, tournament: tournament) }
    let!(:team2) { FactoryGirl.create(:tournament_team, team: away, tournament: tournament) }
    let!(:match) { FactoryGirl.create(:match, home_team_id: team1.id, away_team_id: team2.id, tournament_id: tournament.id, home_score: 10, away_score: 5, winner_id: team1.id) }
    
    it "calc_diff" do
      home_team = match.home_team
      expect(home_team.calc_diff(match)).to eq(5)
    end

    it "winner_points" do
      home_team = match.home_team
      home_team.winner_points
      expect(home_team.wins).to eq(1)
      expect(home_team.total_points).to eq(3)
    end

    it "loser_points" do
      home_team = match.home_team
      home_team.loser_points
      expect(home_team.losses).to eq(1)
      expect(home_team.total_points).to eq(0)
    end

  end
end
