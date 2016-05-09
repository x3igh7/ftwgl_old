class TournamentTeam < ActiveRecord::Base
  attr_accessible :team, :tournament, :rank, :challonge_id
  attr_protected :total_points, :total_diff, :wins, :losses

  validates_presence_of :team, :tournament, :total_points, :total_diff, :wins, :losses
  validates_uniqueness_of :team_id, scope: :tournament_id
  belongs_to :team
  belongs_to :tournament
  has_many :home_matches, foreign_key: 'away_team_id', class_name: 'Match'
  has_many :away_matches, foreign_key: 'home_team_id', class_name: 'Match'
  has_many :tournament_team_memberships, dependent: :destroy

  def members
    if tournament_team_memberships.count < 1
      return []
    end

    tournament_team_memberships
  end

  def available_roster
    available_roster = []
    self.team.memberships.each do |m|
      exists = false

      self.members.each do |tm|
        if m.user_id == tm.user_id
          exists = true
        end
      end

      if !exists && m.active
        available_roster.push(m)
      end
    end

    return available_roster
  end

  def matches
    home_matches + away_matches
  end

  def self.in_tournament(tournament)
    where(tournament_id: tournament.id)
  end

  def self.ranking
    order('total_points DESC', 'total_diff DESC')
  end

  def calcuate_results(match)
    @team = self
    @round_one = 0
    @round_two = 0
    @round_three = 0

    if @team == match.home_team
      @round_one = match.home_team_round_one - match.away_team_round_one
      @round_two = match.home_team_round_two - match.away_team_round_two

      unless match.home_team_round_three.nil?
        @round_three = match.home_team_round_three - match.away_team_round_three
      end
    else
      @round_one = match.away_team_round_one - match.home_team_round_one
      @round_two = match.away_team_round_two - match.home_team_round_two

      unless match.home_team_round_three.nil?
        @round_three = match.home_team_round_three - match.away_team_round_three
      end
    end

    if @round_one > 0 && @round_two > 0
      @team.winner_points
      match.winner_points(@team)
    elsif @round_one < 0 && @round_two < 0
      @team.loser_points
      match.loser_points(@team)
    elsif !match.home_team_round_three.nil? && @round_three > 0
      @team.winner_points
      match.winner_points(@team)
    else
      @team.draw_points
      match.draw_points(@team)
    end

    @team.total_diff += @round_one + @round_two + @round_three
  end

  def winner_points
    self.wins += 1
    self.total_points += 4
  end

  def loser_points
    self.losses += 1
    self.total_points += 0
  end

  def draw_points
    self.draws += 1
    self.total_points += 2
  end

  def has_played?(tournament_team)
    matches.each do |match|
      if match.away_team_id == tournament_team.id or match.home_team_id == tournament_team.id
        return true
      end
    end

    return false
  end

  def has_not_played(teams)
    has_not_played = []
    teams.each do |team|
      if self.has_played?(team) == false
        has_not_played << team
      end
    end
    has_not_played.delete(self)
    has_not_played.sort!{|a,b| a.rank <=> b.rank}
  end

end
