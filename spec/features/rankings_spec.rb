require 'spec_helper'

describe "Rankings" do
  team = FactoryGirl.create(:team)
  team2 = FactoryGirl.create(:team)
  team3 = FactoryGirl.create(:team)
  tournament = FactoryGirl.create(:tournament)
  it "ranks teams from most points to lowest points" do
    tounry_team = FactoryGirl.create(:tournament_team, team: team, :wins => 3, :total_points => 9)
    tourny_team2 = FactoryGirl.create(:tournament_team, team: team2, :wins => 2, :losses => 1, :total_points => 6)
    tourny_team3 = FactoryGirl.create(:tournament_team, team: team3, :wins => 1, :losses => 2, :total_points => 3)

    visit tournament_rankings_path(tournament)
    expect(page.find("#rank1 .rank")).to have_content(1)
    expect(page.find("#rank1 .name")).to have_content(team.name)
    expect(page.find("#rank3 .rank")).to have_content(3)
    expect(page.find("#rank3 .name")).to have_content(team3.name) 
  end

  it "ranks teams from highest diff to lowest diff if points are equal" do
    tounry_team = FactoryGirl.create(:tournament_team, team: team, :total_diff => 10)
    tourny_team2 = FactoryGirl.create(:tournament_team, team: team2, :total_diff => 6)
    tourny_team3 = FactoryGirl.create(:tournament_team, team: team3, :total_diff => 3)

    visit tournament_rankings_path(tournament)
    expect(page.find("#rank1 .rank")).to have_content(1)
    expect(page.find("#rank1 .name")).to have_content(team.name)
    expect(page.find("#rank2 .rank")).to have_content(2)
    expect(page.find("#rank2 .name")).to have_content(team2.name)
    expect(page.find("#rank3 .rank")).to have_content(3)
    expect(page.find("#rank3 .name")).to have_content(team3.name)
  end
end
