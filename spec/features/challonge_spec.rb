require 'spec_helper'

describe "Challonge integration" do

  let!(:admin) {FactoryGirl.create(:user) }

  before do
    admin.roles = :admin
    admin.save
    sign_in_as(admin)
  end

  it "tournaments can be created as brackets", :js => true do
    new_tournament = FactoryGirl.build(:tournament)
    visit admin_root_path
    prev = Tournament.count

    visit admin_root_path
    click_on "create new tournament"

    select "Bracket", from: "Tournament type"
    fill_in "Name", :with => new_tournament.name
    fill_in "Description", :with => new_tournament.description
    fill_in "Rules", :with => new_tournament.rules
    select "Teams", from: "Bracket type"
    select "Single", from: "Elimination type"
    fill_in "Bracket size", with: 16

    click_on "Create Tournament"

    expect(Tournament.count).to eq(prev + 1)
    expect(Tournament.last.tournament_type).to eq("Bracket")
    expect(page).to have_content(new_tournament.name)
  end

end

def manage
  visit admin_root_path
  click_button "manage"
end
