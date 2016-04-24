class TournamentTeamMembership < ActiveRecord::Base
  attr_accessible :tournament_team, :tournament, :user, :authorization_id
  validates_presence_of :tournament_team, :user
  validates_uniqueness_of :user_id, scope: :tournament_id

  belongs_to :tournament_team
  belongs_to :user
  belongs_to :tournament
end
