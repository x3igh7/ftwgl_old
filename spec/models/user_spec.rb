require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:username) }
  it { should have_many(:teams) }
  it { should have_many(:memberships) }
  it { should have_many(:tournaments) }
  it { should have_many(:news) }
  it { should have_many(:matches) }
  it { should have_many(:comments) }
  it { should have_many(:tournament_admins) }
end

describe "is_tournament_admin?" do
  let!(:admin) {FactoryGirl.create(:user)}
  let!(:non_admin) {FactoryGirl.create(:user)}
  let!(:tournament) {FactoryGirl.create(:tournament)}
  let!(:tournament_admin) {FactoryGirl.create(:tournament_admin, user: admin, tournament: tournament)}

  it "returns true if is a tournament admin" do
    expect(admin.is_tournament_admin?).to be_true
  end

  it "returns false if not a tournament admin" do
    expect(non_admin.is_tournament_admin?).to be_false
  end
end

describe "admin_tournaments", :focus => true do
  let!(:admin) {FactoryGirl.create(:user)}
  let!(:tournament) {FactoryGirl.create(:tournament)}
  let!(:tournament2) {FactoryGirl.create(:tournament)}
  let!(:tournament3) {FactoryGirl.create(:tournament)}
  let!(:tournament_admin) {FactoryGirl.create(:tournament_admin, user: admin, tournament: tournament)}
  let!(:tournament_admin2) {FactoryGirl.create(:tournament_admin, user: admin, tournament: tournament2)}

  it "returns array of tournaments they are admin of" do
    expect(admin.admin_tournaments).to include(tournament)
    expect(admin.admin_tournaments).to include(tournament2)
  end

  it "does not return tournaments they arent admin of" do
    expect(admin.admin_tournaments).to_not include(tournament3)
  end
end

describe "is_team_owner?" do
  let!(:team_owner) {FactoryGirl.create(:user) }
  let!(:team) { FactoryGirl.create(:team) }
  let!(:member) {FactoryGirl.create(:membership, team: team, user: team_owner, role: 'owner', active: true)}
  it "returnes true if user is team owner" do
    expect(team_owner.is_team_owner?(team)).to be_true
  end
end

describe "is_team_member?" do
  let!(:user) {FactoryGirl.create(:user) }
  let!(:team) { FactoryGirl.create(:team) }
  let!(:member) {FactoryGirl.create(:membership, team: team, user: user, active: true)}
  it "returnes true if user is team owner" do
    expect(user.is_team_member?(team)).to be_true
  end
end

describe "update_and_remove_tournament_admins" do
  let!(:user) {FactoryGirl.create(:user) }
  let!(:tournament) { FactoryGirl.create(:tournament) }
  let!(:tournament_admin) { FactoryGirl.create(:tournament_admin, user: user, tournament: tournament) }

  it "removes associated tournament_admins" do
    prev_count = user.tournament_admins.count
    params = {:user => {:username => 'testing'}}
    user.update_and_remove_tournament_admins(params[:user], user.id)
    @changed_user = User.find(user.id)
    expect(@changed_user.tournament_admins.count).to eq(prev_count - 1)
  end
end


describe "user stats" do
  let!(:user) {FactoryGirl.create(:user) }
  let!(:home) { FactoryGirl.create(:team) }
  let!(:member) {FactoryGirl.create(:membership, team: home, user: user, role: 'owner', active: true)}
  let!(:away) { FactoryGirl.create(:team) }
  let!(:tournament) { FactoryGirl.create(:tournament) }
  let!(:team1) { FactoryGirl.create(:tournament_team, team: home, tournament: tournament, wins: 2, losses: 1) }
  let!(:team2) { FactoryGirl.create(:tournament_team, team: away, tournament: tournament, wins: 1, losses: 2) }
  let!(:match) { FactoryGirl.create(:match, home_team_id: team1.id, away_team_id: team2.id, tournament_id: tournament.id, home_score: 10, away_score: 5, winner_id: team1.id) }
  let!(:match2) { FactoryGirl.create(:match, home_team_id: team1.id, away_team_id: team2.id, tournament_id: tournament.id, home_score: 10, away_score: 5, winner_id: team1.id) }
  let!(:match3) { FactoryGirl.create(:match, home_team_id: team1.id, away_team_id: team2.id, tournament_id: tournament.id, home_score: 5, away_score: 10, winner_id: team2.id) }


  it "calculates a users total wins" do
    expect(user.total_wins).to eq(2)
  end

  it "calculates a users total losses" do
    expect(user.total_losses).to eq(1)
  end

  it "calulates total matches" do
    expect(user.total_matches).to eq(3)
  end

  it "calculates a a users winning perc" do
    expect(user.winning_perc).to eq(2.0/3.0)
  end

end
