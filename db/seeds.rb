# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create(username: 'x8', password: 'administrator', email: 'x3igh7@gmail.com')
user.confirmed_at = DateTime.now
user.roles = :admin
user.save

user2 = User.create(username: 'x9', password: 'administrator', email: 'forthewin@gmail.com')
user2.confirmed_at = DateTime.now
user2.roles = :admin
user2.save

user3 = User.create(username: 'x7', password: 'administrator', email: 'connerpsmith@gmail.com')
user3.confirmed_at = DateTime.now
user3.save

team = Team.create(name: 'foo', tag: '[bar]')
team2 = Team.create(name: 'bar', tag: '[foo]')

member = Membership.create(user: user, team: team, role: 'owner', active: true)
Membership.create(user: user2, team: team2, role: 'owner', active: true)
Membership.create(user: user3, team: team, role: 'member', active: true)

tournament = Tournament.create(name: 'Season 1', category: 'Urban Terror', tournament_type: 'Season')
tournament.active = true
tournament.save

tournament_team = TournamentTeam.create(tournament: tournament, team: team)
tournament_team2 = TournamentTeam.create(tournament: tournament, team: team2)
