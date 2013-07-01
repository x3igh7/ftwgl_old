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
end
