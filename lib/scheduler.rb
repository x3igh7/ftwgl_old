module MatchScheduler
  def generate_potential_matches(already_scheduled, team)
    if already_scheduled.include?(team)==false
      potential_teams = team.has_not_played(teams) #has_not_played is ordered by rank
      already_scheduled.each do |a_team|
        if potential_teams.include?(a_team)
          potential_teams.delete(a_team)
        end
      end
    end
    potential_teams
  end
end
