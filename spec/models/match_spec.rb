require 'spec_helper'

describe Match do
  it { should belong_to :home_team }
  it { should belong_to :away_team }
  it { should belong_to :tournament }
  it { should validate_presence_of :home_team }
  it { should validate_presence_of :away_team }
  it { should validate_presence_of :week_num }
  it { should validate_presence_of :match_date }
  it { should validate_presence_of :tournament }
  it { should validate_presence_of :home_score }
  it { should validate_presence_of :away_score }
  it { should validate_numericality_of :home_score }
  it { should validate_numericality_of :away_score }
  it { should validate_numericality_of :week_num }

  describe "update_tourny_team_scores" do
    let!(:team_owner) { FactoryGirl.create(:user) }
    let!(:home) { FactoryGirl.create(:team) }
    let!(:member) {FactoryGirl.create(:membership, team: home, user: team_owner, role: 'owner', active: true)}
    let!(:away) { FactoryGirl.create(:team) }
    let!(:tournament) { FactoryGirl.create(:tournament) }
    let!(:team1) { FactoryGirl.create(:tournament_team, team: home, tournament: tournament) }
    let!(:team2) { FactoryGirl.create(:tournament_team, team: away, tournament: tournament) }
    let!(:match) { FactoryGirl.create(:match, home_team_id: team1.id, away_team_id: team2.id, tournament_id: tournament.id, home_score: 10, away_score: 5, winner_id: team1.id) }

    it "updates the scores and diff of tounry teams" do
      match.update_tourny_teams_scores
      expect(match.home_team.total_points).to eq(3)
      expect(match.away_team.total_diff).to eq(-5)
    end

  end

end
