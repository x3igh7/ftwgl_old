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

    it { should validate_uniqueness_of(:team_id).scoped_to(:tournament_id) }
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

  describe "has_not_played" do
    let!(:tournament1) {FactoryGirl.create(:tournament)}
    let!(:team) { FactoryGirl.create(:team) }
    let!(:team2) { FactoryGirl.create(:team) }
    let!(:team3) { FactoryGirl.create(:team) }
    let!(:team4) { FactoryGirl.create(:team) }
    let!(:tournament_team) {FactoryGirl.create(:tournament_team, team: team, tournament: tournament1, rank: 6)}
    let!(:tournament_team2) {FactoryGirl.create(:tournament_team, team: team2, tournament: tournament1, rank: 5)}
    let!(:tournament_team3) {FactoryGirl.create(:tournament_team, team: team3, tournament: tournament1, rank: 4)}
    let!(:tournament_team4) {FactoryGirl.create(:tournament_team, team: team4, tournament: tournament1, rank: 3)}
    let!(:match) { FactoryGirl.create(:match, home_team_id: tournament_team.id, away_team_id: tournament_team2.id, tournament_id: tournament1.id) }

    it "has_played? method checks if a tournament team has already played a specified tournament team" do
      check = tournament_team.has_played?(team2)
      expect(check).to be_true
    end

    it "has_not_played returns an array of teams not yet played yet, ordered by rank", :focus => true do
      teams = TournamentTeam.where(tournament_id: tournament1.id)
      potential_opponents = tournament_team.has_not_played(teams)
      expect(potential_opponents).to eq([tournament_team4, tournament_team3])
    end
  end
end
