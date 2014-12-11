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
    manage
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

  context "Match Creation" do
    let!(:bracket_tournament) {FactoryGirl.create(:tournament, tournament_type: "Bracket", challonge_state: "underway", challonge_id: 831138)}
    let!(:team) { FactoryGirl.create(:team) }
    let!(:team2) { FactoryGirl.create(:team) }
    let!(:team3) { FactoryGirl.create(:team) }
    let!(:team4) { FactoryGirl.create(:team) }
    let!(:tournament_team) {FactoryGirl.create(:tournament_team, team: team, tournament: bracket_tournament, challonge_id: 12611718)}
    let!(:tournament_team2) {FactoryGirl.create(:tournament_team, team: team2, tournament: bracket_tournament, challonge_id: 12611728)}
    let!(:tournament_team3) {FactoryGirl.create(:tournament_team, team: team3, tournament: bracket_tournament, challonge_id: 12611723)}
    let!(:tournament_team4) {FactoryGirl.create(:tournament_team, team: team4, tournament: bracket_tournament, challonge_id: 12611725)}

    it "matches can be created after tournament is started based on bracket", :vcr => {:record => :new_episodes}, :js => true do
      prev = Match.count
      manage
      click_link "generate matches"
      click_on "create matches"
      expect(Match.count).to eq(prev + 2)
      expect(Match.last.challonge_id).to eq(18031474)
    end
  end

  context "Match Results" do
    let!(:bracket_tournament) {FactoryGirl.create(:tournament, tournament_type: "Bracket", challonge_state: "underway", challonge_id: 831138)}
    let!(:team) { FactoryGirl.create(:team) }
    let!(:team2) { FactoryGirl.create(:team) }
    let!(:team3) { FactoryGirl.create(:team) }
    let!(:team4) { FactoryGirl.create(:team) }
    let!(:tournament_team) {FactoryGirl.create(:tournament_team, team: team, tournament: bracket_tournament, challonge_id: 12611718)}
    let!(:tournament_team2) {FactoryGirl.create(:tournament_team, team: team2, tournament: bracket_tournament, challonge_id: 12611728)}
    let!(:tournament_team3) {FactoryGirl.create(:tournament_team, team: team3, tournament: bracket_tournament, challonge_id: 12611723)}
    let!(:tournament_team4) {FactoryGirl.create(:tournament_team, team: team4, tournament: bracket_tournament, challonge_id: 12611725)}
    let!(:match) {FactoryGirl.create(:match, home_team_id: tournament_team.id, away_team_id: tournament_team2.id, tournament_id: bracket_tournament.id, challonge_id: 18031473, home_score: 3, away_score: 1)}
    let!(:match2) {FactoryGirl.create(:match, home_team_id: tournament_team.id, away_team_id: tournament_team2.id, tournament_id: bracket_tournament.id, challonge_id: 18031474, home_score: 2, away_score: 1)}

    it "match results can be updated for bracket", :vcr => {:record => :new_episodes}, :js => true do
      manage
      click_link "update bracket"
      click_on "update"
      expect(page).to have_content("Bracket updated! New matches may be available to generate.")
    end

  end

end

def manage
  visit admin_root_path
  find('#manage-tournaments').click
end
