require 'spec_helper'

describe Match do
  it { should validate_presence_of :home_team }
  it { should validate_presence_of :away_team } 
  it { should validate_presence_of :week_num }
  it { should validate_presence_of :match_date }

  it "returns teams in a tournament" do
    home = FactoryGirl.create(:team)
    away = FactoryGirl.create(:team)
    tournament = FactoryGirl.create(:tournament)
    team1= FactoryGirl.create(:tournament_team, team: home, tournament: tournament)
    team2 = FactoryGirl.create(:tournament_team, team: away, tournament: tournament)
    
    teams = allTournyTeams(tournament)
    expect(teams).to include(home)
    expect(teams).to include(away)
  end
end
