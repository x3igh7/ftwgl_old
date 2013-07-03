class Matches < ActiveRecord::Base
  attr_accessible :match_date, :home_score, :away_score
  attr_protected :winner_id, :home_team, :away_team, :week_num
  validates_presence_of :home_team, :away_team, :week_num, :match_date
end
