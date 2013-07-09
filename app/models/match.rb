class Match < ActiveRecord::Base
  attr_accessible :match_date, :home_score, :away_score, :winner_id
  attr_accessible :home_team_id, :away_team_id, :week_num, :home_team, :away_team
  # attr_protected :home_team, :away_team, :week_num
  validates_presence_of :home_team, :away_team, :week_num, :match_date
  validates_presence_of :tournament, :home_score, :away_score
  
  belongs_to :home_team, :class_name => "TournamentTeam"
  belongs_to :away_team, :class_name => "TournamentTeam"

  belongs_to :tournament
  #NEEDS TO BE TESTED!!!
  def update_tourny_teams_scores
    home_team = self.home_team
    away_team = self.away_team
    home_team.total_diff += (self.home_score - self.away_score)
    away_team.total_diff += (self.away_score - self.home_score)
    if self.home_score > self.away_score
      home_team.wins += 1
      home_team.total_points += 3
      away_team.losses += 1
      away_team.total_points += 0
    else
      away_team.wins += 1
      away_team.total_points += 3
      home_team.losses += 1
      home_team.total_points += 0
    end
    home_team.save && away_team.save
  end
end
