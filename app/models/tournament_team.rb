class TournamentTeam < ActiveRecord::Base
  attr_accessible :team, :tournament
  attr_protected :total_points, :total_diff, :wins, :losses

  validates_presence_of :team, :tournament, :total_points, :total_diff, :wins, :losses
  validates_uniqueness_of :team_id, scoped_to: :tournament_id
  belongs_to :team
  belongs_to :tournament
end
