class Match < ActiveRecord::Base
  attr_accessible :match_date, :home_points, :away_points, :map_name, :week_num, :reported_by, :reported_by_id
  attr_accessible :home_team, :away_team, :winning_team, :tournament_id, :home_team_id, :away_team_id, :winning_team_id
  attr_accessible :home_team_round_one, :home_team_round_two, :home_team_round_three, :home_team_differential
  attr_accessible :away_team_round_one, :away_team_round_two, :away_team_round_three, :away_team_differential
  validates_presence_of :home_team, :away_team, :week_num, :match_date
  validates_presence_of :tournament, :home_team_round_one, :home_team_round_two, :home_points
  validates_presence_of :away_team_round_one, :away_team_round_two, :away_points
  validates_numericality_of :home_points, :away_points, :week_num
  validates_numericality_of :home_team_round_one, :home_team_round_two
  validates_numericality_of :away_team_round_one, :away_team_round_two

  validate :team_cannot_play_against_itself

  belongs_to :home_team, :class_name => 'TournamentTeam'
  belongs_to :away_team, :class_name => 'TournamentTeam'
  belongs_to :winning_team, :class_name => 'TournamentTeam', :foreign_key => 'winner_id'
  belongs_to :tournament
  belongs_to :reported_by, :class_name => 'User', :foreign_key => 'reported_by_id'
  belongs_to :disputed_by, :class_name => 'User', :foreign_key => 'disputed_by_id'

  has_many :match_screenshots
  has_many :comments, :as => :commentable, :dependent => :destroy

  def match_results_complete
    if home_team_round_one && home_team_round_two && away_team_round_one && away_team_round_two
      if home_team_round_one == 0 && home_team_round_two == 0 && away_team_round_one == 0 && away_team_round_two == 0
        return false
      end

      if home_team_round_one == away_team_round_one
        return false
      end

      if home_team_round_two == away_team_round_two
        return false
      end

      if home_team_round_three.nil? && away_team_round_three.nil?
        return true
      end

      if !home_team_round_three.nil? && away_team_round_three.nil?
        return false
      end

      if home_team_round_three.nil? && !away_team_round_three.nil?
        return false
      end

      if !home_team_round_three.nil? && !away_team_round_three.nil?
        if home_team_round_three == away_team_round_three
          return false
        end
      end

      return true
    end
  end

  def update_match_results(user = nil)
    unless(user.nil?)
      self.reported_by = current_user
    end

    if !self.match_results_complete
      return false
    end

    @home_team = self.home_team
    @away_team = self.away_team
    @match = self

    calcuate_results(@home_team)
    calcuate_results(@away_team)

    if self.home_points > self.away_points
      @match.winning_team = home_team
    elsif self.home_points < self.away_points
      @match.winning_team = away_team
    else
      @match.is_draw = true
    end

    @match.save
  end

  def team_cannot_play_against_itself
    if home_team_id == away_team_id
      errors.add(:home_team_id, 'is the same as away_team_id')
    end
  end

  def save_and_update_match_results(user = nil)
    Match.transaction do
      update_attributes(params[:match]) && self.update_match_results(user)
    end
  end

  def winner_points(team)
    if team == home_team
      self.home_points = 4
    else
      self.away_points = 4
    end
  end

  def loser_points(team)
    if team == home_team
      self.home_points = 0
    else
      self.away_points = 0
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

  private

  def calcuate_results(team)
    @team = team
    @match = self
    @round_one = 0
    @round_two = 0
    @round_three = 0

    if @team == @match.home_team
      @round_one = @match.home_team_round_one - @match.away_team_round_one
      @round_two = @match.home_team_round_two - @match.away_team_round_two

      unless @match.home_team_round_three.nil?
        @round_three = @match.home_team_round_three - @match.away_team_round_three
      end

      @match.home_team_differential += @round_one + @round_two + @round_three
    else
      @round_one = @match.away_team_round_one - @match.home_team_round_one
      @round_two = @match.away_team_round_two - @match.home_team_round_two

      unless @match.home_team_round_three.nil?
        @round_three = @match.home_team_round_three - @match.away_team_round_three
      end

      @match.away_team_differential += @round_one + @round_two + @round_three
    end

    if @round_one > 0 && @round_two > 0
      @match.winner_points(@team)
    elsif @round_one < 0 && @round_two < 0
      @match.loser_points(@team)
    elsif !@match.home_team_round_three.nil? && @round_three > 0
      @match.winner_points(@team)
    else
      @match.draw_points(@team)
    end
  end
end
