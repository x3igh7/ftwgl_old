class TournamentTeam < ActiveRecord::Base
  attr_accessible :team, :tournament, :challonge_id

  validates_presence_of :team, :tournament
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

  def wins
    @wins = 0

    unless away_matches.nil? || home_matches.nil?
      away_wins = self.away_matches.where(is_draw: false).where(winner_id: self.id).find_each
      home_wins = self.home_matches.where(is_draw: false).where(winner_id: self.id).find_each

      unless away_wins.nil?
        @wins += away_wins.count
      end

      unless home_wins.nil?
        @wins += home_wins.count
      end
    end

    return @wins
  end

  def losses
    @losses = 0

    unless away_matches.nil? || home_matches.nil?
      away_losses = self.away_matches.where(is_draw: false).where("winner_id != ?", self.id)
      home_losses = self.home_matches.where(is_draw: false).where("winner_id != ?", self.id)

      unless away_losses.nil?
        @losses += away_losses.count
      end

      unless home_losses.nil?
        @losses += home_losses.count
      end
    end

    return @losses
  end

  def draws
    @draws = 0

    unless away_matches.nil? || home_matches.nil?
      away_draws = self.away_matches.where(is_draw: true)
      home_draws = self.home_matches.where(is_draw: true)

      unless away_draws.nil?
        @draws += away_draws.count
      end

      unless away_draws.nil?
        @draws += away_draws.count
      end
    end

    return @draws
  end

  def differential
    @differential = 0

    unless away_matches.nil? || home_matches.nil?
      away_matches.each do |m|
        @differential += m.away_team_differential
      end

      home_matches.each do |m|
        @differential += m.home_team_differential
      end
    end

    return @differential
  end

  def points
    @points = 0

    unless away_matches.nil? || home_matches.nil?
      away_matches.each do |m|
        @points += m.away_points
      end

      home_matches.each do |m|
        @points += m.home_points
      end
    end

    return @points
  end

  def rank
    tournament.tournament_rankings.find_index(self) + 1
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
