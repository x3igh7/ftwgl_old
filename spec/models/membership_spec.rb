require 'spec_helper'

describe Membership do
  it { should belong_to :team }
  it { should belong_to :user }

  it { should validate_presence_of :team }
  it { should validate_presence_of :user }
  it { should validate_presence_of :role }

  it { should ensure_inclusion_of(:role).in_array(%w(owner member)) }
  
  describe "should have 1 membership per user per team" do
    team = FactoryGirl.build(:team)
    user = FactoryGirl.build(:user)
    before do
      FactoryGirl.create(:membership, team: team, role: 'member')
    end
    
    it { should validate_uniqueness_of(:user_id) }
  end

  describe "should ensure the inclusion of active" do
    it { should have_valid(:active).when(true)}
    it { should have_valid(:active).when(false)}
    it { should_not have_valid(:active).when(nil)}
  end
end
