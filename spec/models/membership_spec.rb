require 'spec_helper'

describe Membership do
  it { should belong_to :team }
  it { should belong_to :user }

  it { should validate_presence_of :team }
  it { should validate_presence_of :user }
  it { should validate_presence_of :role }

  it { should ensure_inclusion_of(:role).in_array(%w(owner member)) }
  
  describe "should have 1 membership per user per team" do
    
    before do
      team = FactoryGirl.build(:team)
      user = FactoryGirl.build(:user) 
      FactoryGirl.create(:membership, team: team, role: 'member')
    end
    
    it { should validate_uniqueness_of(:user_id).scoped_to(:team_id) }

    it "allows a user to join multiple teams" do
      first_team = FactoryGirl.create(:team)
      second_team = FactoryGirl.create(:team)
      user = FactoryGirl.create(:user)

      FactoryGirl.create(:membership, user: user, team: first_team)
      membership = FactoryGirl.build(:membership, user: user, 
          team: second_team)

      membership.save.should be_true
    end

    it "does not allow a user to join the same team twice" do
      team = FactoryGirl.create(:team)
      user = FactoryGirl.create(:user)

      FactoryGirl.create(:membership, user: user, team: team)
      membership = FactoryGirl.build(:membership, user: user, team: team)

      membership.save.should be_false
    end

  end

  describe "should ensure the inclusion of active" do
    it { should have_valid(:active).when(true)}
    it { should have_valid(:active).when(false)}
    it { should_not have_valid(:active).when(nil)}
  end
end
