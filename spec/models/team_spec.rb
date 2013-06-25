require 'spec_helper'

describe Team do  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:tag) }

  it "shows the team owners" do
    team = FactoryGirl.create(:team)
    user = FactoryGirl.create(:user)
    FactoryGirl.create(:membership, team: team, role: 'user')
    FactoryGirl.create(:membership, team: team, user: user, role: 'owner')

    team.owners.should include(user)
  end

  it "creates a new team from an owner" do
    user = FactoryGirl.create(:user)

    team = Team.new(name: 'foo', tag: '[bar]')
    team.save_with_owner(user).should be_true
    team.owners.should include(user)
  end
end

