require 'spec_helper'

describe "AdminCP Manage Users" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:admin) { FactoryGirl.create(:user) }
  let!(:tournament) { FactoryGirl.create(:tournament) }
  let!(:tournament_admin) { FactoryGirl.create(:tournament_admin, user: user, tournament: tournament) }

  before do
    admin.roles = :admin
    admin.save
    sign_in_as(admin)
  end

  it "can edit a User's information" do
    visit admin_root_path
    click_on "manage-#{user.username}"
    fill_in "Username", with: "sephy"
    click_on "Save"
    updated_user = User.find(user.id)
    expect(updated_user.username).to eq("sephy")
    expect(updated_user.roles).to eq(user.roles)
  end

  it "will remove tournament admins if role changes" do
    prev_count = user.tournament_admins.count
    user.roles = :tournament_admin
    user.save
    visit admin_root_path
    click_on "manage-#{user.username}"
    fill_in "Username", with: "testing"
    select "user", from: "user_roles"
    click_on "Save"
    updated_user = User.find(user.id)
    expect(updated_user.username).to eq("testing")
    expect(updated_user.has_role?(:tournament_admin)).to be_false
    expect(updated_user.tournament_admins.count).to eq(prev_count - 1)
  end

  it "can ban a User" do
    visit admin_root_path
    click_on "manage-#{user.username}"
    click_on "ban"
    updated_user = User.find(user.id)
    expect(updated_user.roles).to include(:banned)
  end

  it "can unban a User" do
    user.roles << :banned
    user.save
    expect(user.roles).to include(:banned)
    visit admin_root_path
    click_on "manage-#{user.username}"
    click_on "unban"
    updated_user = User.find(user.id)
    expect(updated_user.roles).to_not include(:banned)
  end

  it "can delete a User" do
    prev = User.count
    visit admin_root_path
    click_on "manage-#{user.username}"
    click_on "delete"
    expect(User.count).to eq(prev - 1)
  end

end
