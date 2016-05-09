class Match < ActiveRecord::Base
  attr_accessible :match_date, :home_score, :away_score, :winning_team
  attr_accessible :home_team_id, :away_team_id, :week_num, :home_team, :away_team
  attr_protected :winner_id
  validates_presence_of :home_team, :away_team, :week_num, :match_date
  validates_presence_of :tournament, :home_score, :away_score
  validates_numericality_of :home_score, :away_score, :week_num
  validate :team_cannot_play_against_itself

  belongs_to :home_team, :class_name => 'TournamentTeam'
  belongs_to :away_team, :class_name => 'TournamentTeam'
  belongs_to :winning_team, :class_name => 'TournamentTeam', :foreign_key => 'winner_id'
  belongs_to :tournament

  has_many :match_screenshots
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

    if home_team.save && away_team.save
      return true
    else
      return false
    end
  end

  def team_cannot_play_against_itself
    if home_team_id == away_team_id
      errors.add(:home_team_id, 'is the same as away_team_id')
    end
  end

  def save_with_team_update


    Match.transaction do
      save and self.update_tourny_teams_scores
    end
  end

  def standard_date
    match_date.strftime("%a, %b %-d, %I:%M%p %Z")
  end

  def self.in_tournament(tournament)
    where(tournament_id: tournament.id)
  end

  def self.current_week_matches(tournament)
    where(week_num: tournament.current_week_num)
  end

end
