require 'spec_helper'

describe "Rankings" do
  let!(:team) { FactoryGirl.create(:team) }
  let!(:team2) { FactoryGirl.create(:team) }
  let!(:team3) { FactoryGirl.create(:team) }
  let!(:tournament) { FactoryGirl.create(:tournament) }
  it "ranks teams from most points to lowest points" do
    FactoryGirl.create(:tournament_team, team: team2, tournament: tournament, :wins => 2, :losses => 1, :total_points => 6)
    FactoryGirl.create(:tournament_team, team: team3, tournament: tournament, :wins => 1, :losses => 2, :total_points => 3)
    FactoryGirl.create(:tournament_team, team: team, tournament: tournament, :wins => 3, :total_points => 9)

    visit tournament_path(tournament)
    expect(page.find("#rank1 .rank")).to have_content(1)
    expect(page.find("#rank1 .name")).to have_content(team.name)
    expect(page.find("#rank3 .rank")).to have_content(3)
    expect(page.find("#rank3 .name")).to have_content(team3.name)
  end

  it "ranks teams from highest diff to lowest diff if points are equal" do
    FactoryGirl.create(:tournament_team, team: team2, tournament: tournament, :total_diff => 6)
    FactoryGirl.create(:tournament_team, team: team3, tournament: tournament, :total_diff => 3)
    FactoryGirl.create(:tournament_team, team: team, tournament: tournament, :total_diff => 10)

    visit tournament_path(tournament)
    expect(page.find("#rank1 .rank")).to have_content(1)
    expect(page.find("#rank1 .name")).to have_content(team.name)
    expect(page.find("#rank2 .rank")).to have_content(2)
    expect(page.find("#rank2 .name")).to have_content(team2.name)
    expect(page.find("#rank3 .rank")).to have_content(3)
    expect(page.find("#rank3 .name")).to have_content(team3.name)
  end
end
