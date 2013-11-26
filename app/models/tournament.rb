class Tournament < ActiveRecord::Base
  attr_accessible :description, :name, :rules, :current_week_num

  validates_presence_of :name
  validates_inclusion_of :active, :in => [true, false]


  has_many :tournament_teams, :dependent => :destroy
  has_many :teams, through: :tournament_teams
  has_many :matches, :dependent => :destroy

  def scheduler
    teams = TournamentTeam.where(tournament_id: self.id).order(:rank)
    @match_counter = 1
    @matches = []
    @already_scheduled = []
    teams.each do |team|
      if @already_scheduled.include?(team)==false
        potential_teams = team.has_not_played(teams) #has_not_played is ordered by rank
        @already_scheduled.each do |a_team|
          if potential_teams.include?(a_team)
            potential_teams.delete(a_team)
          end
          potential_teams
        end
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
              potential_teams = team.has_not_played(teams) #has_not_played is ordered by rank
              @already_scheduled.each do |a_team|
                if potential_teams.include?(a_team)
                  potential_teams.delete(a_team)
                end
                potential_teams
              end
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

end


# shevling this for later... might use it with scheduling
# def rank
#   prev_teams = []
#   teams = self.order("total_points DESC", "total_diff DESC")
#   teams.each_with_index do |team, x|
#     prev_teams << team
#     #checks to see if have the same points and diff
#     #if they do, they have the same rank
#     if prev_teams.last.total_points == team.total_points && prev_teams.last.total_diff == team.total_diff
#       team.rank = prev_teams.last.rank
#     else
#       team.rank = x + 1
#     end
#   end
#   teams
# end
