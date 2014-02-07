require 'spec_helper'

describe "Challonge integration" do

  let!(:admin) {FactoryGirl.create(:user) }

  before do
    admin.roles = :admin
    admin.save
    sign_in_as(admin)
  end

  it "tournaments can be created as brackets", :focus => true do
    new_tournament = FactoryGirl.build(:tournament)
    visit admin_root_path
    prev = Tournament.count

    visit admin_root_path
    click_on "create new tournament"

    fill_in "Name", :with => new_tournament.name
    fill_in "Description", :with => new_tournament.description
    fill_in "Rules", :with => new_tournament.rules
    select "Bracket", from: "Type"
    select "Teams", from: "Bracket Type"
    select "Single", from: "Elimination Type"

    click_on "Create Tournament"

    expect(Tournament.count).to eq(prev + 1)
    expect(Tournament.last.type).to eq("Bracket")
    expect(page).to have_content(new_tournament.name)
  end

def manage
  visit admin_root_path
  click_button "manage"
end
