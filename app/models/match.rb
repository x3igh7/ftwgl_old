class Match < ActiveRecord::Base
  attr_accessible :match_date, :home_score, :away_score, :winner_id
  attr_protected :home_team, :away_team, :week_num
  validates_presence_of :home_team, :away_team, :week_num, :match_date
  
  belongs_to :home_team, :class_name => "Team"
  belongs_to :away_team, :class_name => "Team"

end
