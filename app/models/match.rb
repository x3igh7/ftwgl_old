class Match < ActiveRecord::Base
  attr_accessible :match_date, :home_points, :away_points, :map_name, :week_num
  attr_accessible :home_team, :away_team, :winning_team
  attr_accessible :home_team_round_one, :home_team_round_two, :home_team_round_three
  attr_accessible :away_team_round_one, :away_team_round_two, :away_team_round_three
  attr_protected :winner_id
  validates_presence_of :home_team, :away_team, :week_num, :match_date
  validates_presence_of :tournament, :home_team_round_one, :home_team_round_two
  validates_presence_of :away_team_round_one, :away_team_round_two
  validates_numericality_of :home_points, :away_points, :week_num
  validates_numericality_of :home_team_round_one, :home_team_round_two, :home_team_round_three
  validates_numericality_of :away_team_round_one, :away_team_round_two, :away_team_round_three

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

  def match_results_complete
    if home_team_round_one && home_team_round_two && away_team_round_one && away_team_round_two
      if home_team_round_three.nil? && away_team_round_three.nil?
        return true
      end

      if !home_team_round_three.nil? && away_team_round_three.nil?
        return false
      end


      if home_team_round_three.nil? && !away_team_round_three.nil?
        return false
      end

      return true
    end
  end

  def update_tourny_teams_scores
    @home_team = self.home_team
    @away_team = self.away_team
    @match = self

    home_team.calcuate_results(@match)
    away_team.calcuate_results(@match)

    if self.home_points > self.away_points
      @match.winning_team = home_team
    elsif self.home_points < self.away_points
      @match.winning_team = away_team
    else
      @match.is_draw = true
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
    if !self.match_results_complete
      flash[:error] = 'Match results incomplete.'
      render :edit
    end

    Match.transaction do
      save and self.update_tourny_teams_scores
    end
  end

  def winner_points(team)
    if team == home_team
      self.home_points = 4
    else
      self.away_points = 4
    end
  end

  def draw_points(team)
    if team == home_team
      self.home_points = 2
    else
      self.away_points = 2
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
