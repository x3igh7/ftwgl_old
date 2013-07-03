class TournamentTeam < ActiveRecord::Base
  attr_accessible :team, :tournament
  attr_protected :total_points, :total_diff, :wins, :losses

  validates_presence_of :team, :tournament, :total_points, :total_diff, :wins, :losses
  validates_uniqueness_of :team_id, scoped_to: :tournament_id
  belongs_to :team
  belongs_to :tournament

  def self.in_tournament(tournament)
    where(tournament_id: tournament.id)
  end

  def self.ranking
    order("total_points DESC", "total_diff DESC")
  end
end
