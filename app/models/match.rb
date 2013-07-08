class Match < ActiveRecord::Base
  attr_accessible :match_date, :home_score, :away_score, :winner_id
  attr_accessible :home_team_id, :away_team_id, :week_num, :home_team, :away_team
  # attr_protected :home_team, :away_team, :week_num
  validates_presence_of :home_team, :away_team, :week_num, :match_date
  validates_presence_of :tournament, :home_score, :away_score
  
  belongs_to :home_team, :class_name => "TournamentTeam"
  belongs_to :away_team, :class_name => "TournamentTeam"

  belongs_to :tournament

end
