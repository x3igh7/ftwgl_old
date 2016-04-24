class TournamentTeam < ActiveRecord::Base
  attr_accessible :team, :tournament, :rank, :challonge_id
  attr_protected :total_points, :total_diff, :wins, :losses

  validates_presence_of :team, :tournament, :total_points, :total_diff, :wins, :losses
  validates_uniqueness_of :team_id, scope: :tournament_id
  belongs_to :team
  belongs_to :tournament
  has_many  :home_matches, :foreign_key => 'away_team_id', :class_name => 'Match'
  has_many  :away_matches, :foreign_key => 'home_team_id', :class_name => 'Match'
  has_many :tournament_team_memberships, dependent: :destroy

  def members
    if tournament_team_memberships.count < 1
      return new Array
    end

    tournament_team_memberships
  end

  def matches
    home_matches + away_matches
  end

  def self.in_tournament(tournament)
    where(tournament_id: tournament.id)
  end

  def self.ranking
    order("total_points DESC", "total_diff DESC")
  end

  def calc_diff(match)
    if self.id == match.home_team.id
      self.total_diff += (match.home_score - match.away_score)
    else
      self.total_diff += (match.away_score - match.home_score)
    end
  end

  def winner_points
    self.wins += 1
    self.total_points += 3
  end

  def loser_points
    self.losses += 1
    self.total_points += 0
  end

	def has_played?(tournament_team)
		matches.each do |match|
			if match.away_team_id == tournament_team.id or match.home_team_id == tournament_team.id
				return true
			end
		end
		return false
	end

  def has_not_played(teams)
    has_not_played = []
    teams.each do |team|
      if self.has_played?(team) == false
        has_not_played << team
      end
    end
    has_not_played.delete(self)
    has_not_played.sort!{|a,b| a.rank <=> b.rank}
  end

end
