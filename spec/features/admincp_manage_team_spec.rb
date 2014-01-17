describe "admincp manage teams" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:admin) { FactoryGirl.create(:user) }
  let!(:team) { FactoryGirl.create(:team) }
  let!(:member1) {FactoryGirl.create(:membership, team: team, user: user, role: 'owner', active: false)}

  before do
    admin.roles = :admin
    admin.save
    sign_in_as(admin)
  end

  it "edits the teams" do
    visit admin_root_path
    click_on "manage-#{team.name}"

    fill_in "Name", :with => "bar"
    fill_in "Tag", :with => "[foo]"

    click_on "Update Team"

    expect(page).to have_content("Team Updated Successfully!")
  end

  it "deletes the team" do
    prev = Team.all.count
    visit admin_root_path
    click_on "delete-#{team.name}"
    expect(Team.all.count).to eq(prev - 1)
  end

  it "removes membership" do
    visit admin_root_path
    click_on "manage-#{team.name}"

    valid_user = user.memberships
    click_on "Remove"

    expect(valid_user.exists?).to be_false
  end

end
