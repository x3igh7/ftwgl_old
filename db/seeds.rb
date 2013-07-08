# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create(username: 'x8', password: 'administrator', email: 'conner@gmail.com')
user.roles = :admin
user.save
user2 = User.create(username: 'x3igh7', password: 'administrator', email: 'conners@gmail.com')
team = Team.create(name: 'foo', tag: '[bar]')
Membership.create(user: user, team: team, role: 'owner', active: true )
tournament = Tournament.create(name: "FTW Season 1", description: "Team Survivor", rules: "Don't Cheat")
TournamentTeam.create(team: team, tournament: tournament, wins: 5)
