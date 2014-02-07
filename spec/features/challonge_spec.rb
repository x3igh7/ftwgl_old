require 'spec_helper'

describe "Challonge integration" do

  let!(:admin) {FactoryGirl.create(:user) }

  before do
    admin.roles = :admin
    admin.save
    sign_in_as(admin)
  end

  it "if tournament is a bracket, challonge bracket is created, and rankings are replaced", :vcr => {:record => :new_episodes}, :js => true do
    prev = Tournament.count
    visit admin_root_path
    click_on "create new tournament"
    new_tournament = FactoryGirl.build(:tournament)

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
    expect(Tournament.last.challonge_url.blank?).to be_false
    expect(Tournament.last.challonge_url).to eq("newtestingabc123klj")
    expect(page).to_not have_content("rankings")
  end

end

def manage
  visit admin_root_path
  click_button "manage"
end
