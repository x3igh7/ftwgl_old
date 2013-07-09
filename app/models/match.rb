class Match < ActiveRecord::Base
  attr_accessible :match_date, :home_score, :away_score, :winner_id
  attr_accessible :home_team_id, :away_team_id, :week_num, :home_team, :away_team
  validates_presence_of :home_team, :away_team, :week_num, :match_date
  validates_presence_of :tournament, :home_score, :away_score
  
  belongs_to :home_team, :class_name => "TournamentTeam"
  belongs_to :away_team, :class_name => "TournamentTeam"

  belongs_to :tournament

  def update_tourny_teams_scores
    home_team = self.home_team
    away_team = self.away_team
    home_team.calc_diff(self)
    away_team.calc_diff(self)
    if self.home_score > self.away_score
      home_team.winner_points
      away_team.loser_points
    else
      away_team.winner_points
      home_team.loser_points
    end
    home_team.save && away_team.save
  end

end
