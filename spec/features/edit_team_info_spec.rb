require 'spec_helper'

describe "Editting a team profile" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:team_owner) {FactoryGirl.create(:user) }
  let!(:team) { FactoryGirl.create(:team) }
  let!(:member1) {FactoryGirl.create(:membership, team: team, user: user, role: 'member', active: false)}
  let!(:member2) {FactoryGirl.create(:membership, team: team, user: team_owner, role: 'owner', active: true)}

  it "requires you to be a team owner" do
    sign_in_as team_owner
    
    visit team_path(team)

    click_on "Edit Team Profile"

    expect(current_path).to eq(edit_team_path(team))
  end

  it "cannot be done by a team member" do
    sign_in_as user

    expect(page).to_not have_content("Edit Team Profile")

    visit edit_team_path(team)

    expect(page).to have_content("You are not the owner of this team")
  end

  it "updates your info" do
    sign_in_as team_owner
    visit team_path(team)
    click_on "Edit Team Profile"

    fill_in "Name", :with => "bar"
    fill_in "Tag", :with => "[foo]"

    click_on "Update Team"

    expect(page).to have_content("Team Updated Successfully!")
  end

end
