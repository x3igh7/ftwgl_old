class Match < ActiveRecord::Base
  attr_accessible :match_date, :home_score, :away_score, :winner_id
  attr_accessible :home_team_id, :away_team_id, :week_num, :home_team, :away_team
  validates_presence_of :home_team, :away_team, :week_num, :match_date
  validates_presence_of :tournament, :home_score, :away_score
  validates_numericality_of :home_score, :away_score, :week_num, :winner_id
  validate :team_cannot_play_against_itself

  belongs_to :home_team, :class_name => "TournamentTeam"
  belongs_to :away_team, :class_name => "TournamentTeam"

  belongs_to :tournament

	has_many :comments, :as => :commentable, :dependent => :destroy

	#TODO: add after_destroy callback to rollback changes to tourny team scores
	#OR I would suggest writing a compute points function for tournament model so
	#all points can be calculated at once and will always remain consistent

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

	def team_cannot_play_against_itself
		if home_team_id == away_team_id
			errors.add(:home_team_id, "is the same as away_team_id")
		end
	end

	def standard_date
		match_date.in_time_zone("EST").strftime("%a, %b %-d, %-r %Z")
	end

  def self.in_tournament(tournament)
    where(tournament_id: tournament.id)
  end

end
