class Match < ActiveRecord::Base
  attr_accessible :match_date, :home_score, :away_score, :winner_id
  attr_protected :home_team, :away_team, :week_num
  validates_presence_of :home_team, :away_team, :week_num, :match_date
  
  # def members
  #   actives = memberships.where("active = 'true'")
  #   actives.map { |active| active.user }
  # end

end

  def allTournyTeams(tourny)
    tournyTeams = TournamentTeam.where("tournament_id = '?'", tourny.id)
    teams = []
    tournyTeams.each do |team|
      teams << team
    end
    teams.map { |teams| teams.team }
  end

