require 'spec_helper'

describe Tournament do
  it { should validate_presence_of(:name) }
  it { should have_many(:tournament_teams) }
  it { should have_many(:teams) }
end

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
