class Tournament < ActiveRecord::Base
  attr_accessible :description, :name, :bracket_size, :rules, :current_week_num, :news, :elimination_type, :tournament_type, :bracket_type
  attr_accessible :challonge_url, :challonge_img, :challonge_id, :playoffs
  validates_presence_of :name, :tournament_type

  validates_inclusion_of :active, :in => [true, false]
  validates_inclusion_of :tournament_type, :in => ["", "Season", "Bracket"]
  validates_inclusion_of :bracket_type, :in => ["", "Singles", "Teams"]
  validates_inclusion_of :elimination_type, :in => ["", "Single", "Double"]
  validates :bracket_size, numericality: { only_integer: true }

  TYPES = ["Season", "Bracket"]
  BRACKET_TYPES = ["Teams"] #singles not currently supported
  ELIMINATION_TYPES = ["Single", "Double"]

  has_many :tournament_teams, :dependent => :destroy
  has_many :teams, through: :tournament_teams
  has_many :matches, :dependent => :destroy
  has_many :news, :as => :newsable, :dependent => :destroy



  def scheduler
    teams = TournamentTeam.where(tournament_id: self.id).order(:rank)
    @match_counter = 1
    @matches = []
    @already_scheduled = []
    teams.each do |team|
      if @already_scheduled.include?(team)==false
        potential_teams = potential_teams_calc(@already_scheduled, teams, team)
        if potential_teams == []
          potential_teams = team.has_not_played(teams)
          @matches = []
          @matches << {"match#{@match_counter}" => {"home" => potential_teams.last.id, "away" => team.id}}
          @already_scheduled = []
          @already_scheduled << team
          @already_scheduled << potential_teams.last
          @match_counter = 1
          teams.each do |team|
            if @already_scheduled.include?(team)==false
              potential_teams = potential_teams_calc(@already_scheduled, teams, team)
              @matches << {"match#{@match_counter}" => {"home" => team.id, "away" => potential_teams[0].id}}
              @already_scheduled << team
              @already_scheduled << potential_teams[0]
              @match_counter += 1
            end
            @matches
          end
        else
          @matches << {"match#{@match_counter}" => {"home" => team.id, "away" => potential_teams[0].id}}
          @already_scheduled << team
          @already_scheduled << potential_teams[0]
          @match_counter += 1
        end
      end
    end
    @matches
  end

  def get_challonge_matches
    t = Challonge::Tournament.find(self.challonge_id)
    @matches = t.matches
    @match_counter = 1
    @matchups = []
    @matches.each do |match|
      unless match.player1_id == nil || match.winner_id != nil
        player1 = TournamentTeam.where(challonge_id: match.player1_id)
        player2 = TournamentTeam.where(challonge_id: match.player2_id)
        if player2 == nil
          # if there is no player 2 dont try to make a match
          false
        else
          @matchups << {"match#{@match_counter}" => {"home" => player1[0].id, "away" => player2[0].id, "match_id" => match.id}}
          @match_counter += 1
        end
      end
    end
    return @matchups
  end

  def get_tournament_team_names_by_rank
    team_names = []
    self.tournament_teams.ranking.each do |team|
      team_names << team.team.name
    end
    team_names
  end

  private

  def potential_teams_calc(already_scheduled, all_teams, team)
    potential_teams = team.has_not_played(all_teams) #has_not_played is ordered by rank
    if potential_teams == [] #all available teams have already been played
      potential_teams = all_teams #all teams are then available as opponents and previously played is ignored
    end
    @already_scheduled.each do |a_team|
      if potential_teams.include?(a_team)
        potential_teams.delete(a_team)
      end
      potential_teams
    end
    potential_teams
  end


end
