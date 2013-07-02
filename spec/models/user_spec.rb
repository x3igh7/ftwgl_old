require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:username) }
  it { should have_many(:teams) }
  it { should have_many(:memberships) } 
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

