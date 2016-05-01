class TournamentTeamMembershipsController < ApplicationController
  def create
    @member = TournamentTeamMembership.new
    @tt = TournamentTeam.find(params[:tournament_team])
    @member.tournament_team = @tt
    @member.tournament = @tt.tournament
    @user = User.find(params[:user])
    @member.user = @user

    respond_to do |f|
      if @member.save
        f.html {
          redirect_to tournament_team_path(@tt),
          notice: 'Member was successfully added.'
        }
      else
        f.html {
          redirect_to tournament_team_path(@tt),
          alert: 'Failed to add member.'
        }
      end
    end
  end

  def update
    @member = params[:tournament_team_membership]
    respond_to do |f|
      if @member.save
        f.html {
          redirect_to tournament_team_path(@member.tournament_team),
          notice: 'Member was successfully added.'
        }
      else
        f.html {
          redirect_to tournament_team_path(@tt),
          alert: 'Failed to add member.'
        }
      end
    end
  end

  def destroy
    @member = params[:tournament_team_membership]

    respond_to do |f|
      if @member.destroy
        f.html {
          redirect_to tournament_team_path(@member.tournament_team),
          notice: 'Member was successfully deleted.'
        }
      else
        f.html {
          redirect_to tournament_team_path(@tt),
          alert: 'Failed to delete member.'
        }
      end
    end
  end
end
