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

  # describe "schedule saver", :focus => true do
  #   let!(:tournament1) {FactoryGirl.create(:tournament)}
  #   let!(:team) { FactoryGirl.create(:team) }
  #   let!(:team2) { FactoryGirl.create(:team) }
  #   let!(:team3) { FactoryGirl.create(:team) }
  #   let!(:team4) { FactoryGirl.create(:team) }
  #   let!(:team5) { FactoryGirl.create(:team) }
  #   let!(:team6) { FactoryGirl.create(:team) }
  #   let!(:tournament_team) {FactoryGirl.create(:tournament_team, team: team, tournament: tournament1, rank: 6)}
  #   let!(:tournament_team2) {FactoryGirl.create(:tournament_team, team: team2, tournament: tournament1, rank: 5)}
  #   let!(:tournament_team3) {FactoryGirl.create(:tournament_team, team: team3, tournament: tournament1, rank: 4)}
  #   let!(:tournament_team4) {FactoryGirl.create(:tournament_team, team: team4, tournament: tournament1, rank: 3)}
  #   let!(:tournament_team5) {FactoryGirl.create(:tournament_team, team: team5, tournament: tournament1, rank: 2)}
  #   let!(:tournament_team6) {FactoryGirl.create(:tournament_team, team: team6, tournament: tournament1, rank: 1)}

  #   it "saves multiple matches" do
  #   prev = Match.all.count

  #   matches = [
  #     {"home_team_id"=>"3", "away_team_id"=>"2"},
  #     {"home_team_id"=>"6", "away_team_id"=>"5"},
  #     {"home_team_id"=>"4", "away_team_id"=>"1"}
  #   ]

  #   params = {"week"=>"1",
  #     "match_date"=>
  #       {"date(1i)"=>"2013",
  #        "date(2i)"=>"12",
  #        "date(3i)"=>"14",
  #        "date(4i)"=>"22",
  #        "date(5i)"=>"47"},
  #     "matches"=>
  #       [{"home_team_id"=>"3", "away_team_id"=>"2"},
  #        {"home_team_id"=>"6", "away_team_id"=>"5"},
  #        {"home_team_id"=>"4", "away_team_id"=>"1"}],
  #     "tournament_id"=>"1"}

  #     matches.save_schedule(params)
  #     expect(Match.all.count).to eq(prev+3)
  #   end
  # end

end
