require 'spec_helper'

describe "Team roster" do
  
  context "applications" do
    let(:user) { FactoryGirl.create(:user) }
    let(:team_owner) {FactoryGirl.create(:user) }
    let(:team) { FactoryGirl.create(:team) }
    
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
    let(:user) { FactoryGirl.create(:user) }
    let(:team_owner) {FactoryGirl.create(:user) }
    let(:team) { FactoryGirl.create(:team) }

    it "can be approved by a team owner" do
      FactoryGirl.create(:membership, team: team, user: team_owner, role: 'owner', active: true)


    end

    it "can be rejected by a team owner" do
    end

  end

end
