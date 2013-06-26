require 'spec_helper'

describe "Team roster" do
  
  context "applications" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:team_owner) {FactoryGirl.create(:user) }
    let!(:team) { FactoryGirl.create(:team) }
    
    before :each do
      sign_in_as user
    end

    it "can be submitted by a user" do
      visit team_path(team)

      click_on "Apply to Team"
      expect(page).to have_content("Application submitted")
    end
    
    it "appears as Pending" do
      FactoryGirl.create(:membership, team: team, user: team_owner, role: 'owner', active: true)
      
      visit team_path(team)
      expect(page).to have_content("#{team_owner.username}")

      click_on "Apply to Team"
      expect(page).to have_content("Pending")
    end

  end


  context "pending application" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:team_owner) {FactoryGirl.create(:user) }
    let!(:team) { FactoryGirl.create(:team) }
    let!(:member1) {FactoryGirl.create(:membership, team: team, user: user, role: 'member', active: false)}
    let!(:member2) {FactoryGirl.create(:membership, team: team, user: team_owner, role: 'owner', active: true)}


    before :each do
      sign_in_as team_owner
    end

    it "can be approved by a team owner" do

      visit team_path(team)
      click_button "Approve"

      expect(user.memberships.last.active).to be_true
      expect(page).to_not have_content("Pending")
    end

    it "can be rejected by a team owner" do
    end

  end

end
