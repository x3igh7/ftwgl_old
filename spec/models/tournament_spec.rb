require 'spec_helper'

describe Tournament do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:tournament_type) }
  it { should have_many(:tournament_teams) }
  it { should have_many(:teams) }
  it { should have_many(:matches) }
  it { should ensure_inclusion_of(:tournament_type).in_array(%w(Season Bracket)) }
  it { should ensure_inclusion_of(:bracket_type).in_array(%w(Singles Teams)) }
  it { should ensure_inclusion_of(:elimination_type).in_array(%w(Single Double)) }
  it { should validate_numericality_of :bracket_size }

  describe "rank" do
    let!(:team) { FactoryGirl.create(:team) }
    let!(:team2) { FactoryGirl.create(:team) }
    let!(:team3) { FactoryGirl.create(:team) }
    let!(:tournament) { FactoryGirl.create(:tournament) }
    it "sets team ranks from highest to lowest points" do
      tourny1 = FactoryGirl.create(:tournament_team, team: team3, tournament: tournament, :wins => 1, :losses => 2, :total_points => 3)
      tourny2 = FactoryGirl.create(:tournament_team, team: team2, tournament: tournament, :wins => 2, :losses => 1, :total_points => 6)
      tourny3 = FactoryGirl.create(:tournament_team, team: team, tournament: tournament, :wins => 3, :total_points => 9)

      teams = tournament.tournament_teams.ranking
      expect(teams[2]).to eq(tourny1)
      expect(teams[1]).to eq(tourny2)
      expect(teams[0]).to eq(tourny3)
    end

    it "sets teams ranks from highest to lowest points" do
      tourny1 = FactoryGirl.create(:tournament_team, team: team3, tournament: tournament, :wins => 1, :losses => 2, :total_points => 3)
      tourny2 = FactoryGirl.create(:tournament_team, team: team2, tournament: tournament, :wins => 2, :losses => 1, :total_points => 6, :total_diff => 4)
      tourny3 = FactoryGirl.create(:tournament_team, team: team, tournament: tournament, :wins => 2, :losses => 1, :total_points => 6, :total_diff => 5)

      teams = tournament.tournament_teams.ranking
      expect(teams[2]).to eq(tourny1)
      expect(teams[1]).to eq(tourny2)
      expect(teams[0]).to eq(tourny3)
    end
  end

  describe "should ensure the inclusion of active" do
    it { should have_valid(:active).when(true)}
    it { should have_valid(:active).when(false)}
    it { should_not have_valid(:active).when(nil)}
  end

  describe "generate matches" do
    DatabaseCleaner.clean
    let!(:bracket_tournament) {FactoryGirl.create(:tournament, tournament_type: "Bracket", challonge_id: 830806)}
    let!(:tournament1) {FactoryGirl.create(:tournament)}
    let!(:team) { FactoryGirl.create(:team) }
    let!(:team2) { FactoryGirl.create(:team) }
    let!(:team3) { FactoryGirl.create(:team) }
    let!(:team4) { FactoryGirl.create(:team) }
    let!(:team5) { FactoryGirl.create(:team) }
    let!(:team6) { FactoryGirl.create(:team) }
    let!(:tournament_team) {FactoryGirl.create(:tournament_team, team: team, tournament: tournament1, rank: 6)}
    let!(:tournament_team2) {FactoryGirl.create(:tournament_team, team: team2, tournament: tournament1, rank: 5)}
    let!(:tournament_team3) {FactoryGirl.create(:tournament_team, team: team3, tournament: tournament1, rank: 4)}
    let!(:tournament_team4) {FactoryGirl.create(:tournament_team, team: team4, tournament: tournament1, rank: 3)}
    let!(:tournament_team5) {FactoryGirl.create(:tournament_team, team: team5, tournament: tournament1, rank: 2)}
    let!(:tournament_team6) {FactoryGirl.create(:tournament_team, team: team6, tournament: tournament1, rank: 1)}

    it "suggests a match between the correct teams" do
      matches = tournament1.scheduler
      expect(matches[0]["match1"]["home"]).to eq(tournament_team6.id)
      expect(matches[0]["match1"]["away"]).to eq(tournament_team5.id)
    end

    it "won't suggest a match between 2 teams if they have already played against eachother" do
      FactoryGirl.create(:match, home_team_id: tournament_team2.id, away_team_id: tournament_team.id, tournament_id: tournament1.id)
      FactoryGirl.create(:match, home_team_id: tournament_team4.id, away_team_id: tournament_team3.id, tournament_id: tournament1.id)
      FactoryGirl.create(:match, home_team_id: tournament_team6.id, away_team_id: tournament_team5.id, tournament_id: tournament1.id)

      matches = tournament1.scheduler
      expect(matches[0]["match3"]["home"]).to eq(tournament_team3.id)
      expect(matches[0]["match3"]["away"]).to eq(tournament_team2.id)
      expect(matches[1]["match1"]["home"]).to eq(tournament_team6.id)
      expect(matches[1]["match1"]["away"]).to eq(tournament_team4.id)
      expect(matches[2]["match2"]["home"]).to eq(tournament_team5.id)
      expect(matches[2]["match2"]["away"]).to eq(tournament_team.id)
    end

    context "bracket tournament" do
      let!(:bracket_tournament) {FactoryGirl.create(:tournament, tournament_type: "Bracket", challonge_state: "underway", challonge_id: 830806)}
      let!(:team) { FactoryGirl.create(:team) }
      let!(:team2) { FactoryGirl.create(:team) }
      let!(:tournament_team) {FactoryGirl.create(:tournament_team, team: team, tournament: bracket_tournament, challonge_id: 12607421)}
      let!(:tournament_team2) {FactoryGirl.create(:tournament_team, team: team2, tournament: bracket_tournament, challonge_id: 12607422)}


      it "will list bracket matches from challonge", :vcr do
        matches = bracket_tournament.get_challonge_matches
        expect(matches.count).to eq(1)
      end

    end

  end

end

