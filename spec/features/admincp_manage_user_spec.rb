require 'spec_helper'

describe "AdminCP Manage Users" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:admin) { FactoryGirl.create(:user) }

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
