class Admin::TournamentsController < AdminController

  def index
    @tournaments = Tournament.all
  end

  def new
    @tournament = Tournament.new
    @types = Tournament::TYPES
    @bracket_types = Tournament::BRACKET_TYPES
    @elimination_types = Tournament::ELIMINATION_TYPES
  end

  def create
    @tournament = Tournament.new(params[:tournament])
    if @tournament.tournament_type == "Bracket"
      t = Challonge::Tournament.new
      t.name = @tournament.name
      t.subdomain = "ftwgamingleague"
      if @tournament.elimination_type == "Single"
        t.tournament_type = "single elimination"
      elsif @tournament.elimination_type == "Double"
        t.tournament_type = "double elimination"
      end
      if Rails.env == "production" || Rails.env == "development" #For testing purposes
        t.url = Devise.friendly_token.first(5)
      else
        t.url = "newtestingabc123klj"
      end
      if t.save
        t.reload

        @tournament.challonge_url = t.url
        @tournament.challonge_img = t.live_image_url
        @tournament.challonge_id = t.id
        if @tournament.save
          redirect_to tournament_path(@tournament)
          flash[:notice] = "Successfully created tournament"
        end
      else
        flash[:alert] = t.errors.full_messages
        redirect_to :back
      end
    else
      if @tournament.save
        redirect_to tournament_path(@tournament)
        flash[:notice] = "Successfully created tournament"
      else
        flash[:alert] = "Failed to create tournament"
        render :new
      end
    end
  end

  def edit
    @tournament = Tournament.find(params[:id])
    enforce_tournament_admin_tournament(@tournament)
    @admins = @tournament.tournament_admins
    @users = User.all
    # @success = false

    @admins = @admins.map { |admin| admin.user_id.to_s }
    @users = @users.map { |user| [user.username, user.id] }
  end

  def update
    @tournament = Tournament.find(params[:id])
    @admins = @tournament.tournament_admins.map { |admin| admin.user.id }
    @create_admins = []

    if params.include? 'admins'
    	@param_admins = params[:admins].map { |admin| admin.to_i }
      @new_admins = @param_admins - @admins
      @old_admins = @admins - @param_admins

      @new_admins.each do |admin|
        user = User.find(admin)
        @create_admins << {:user => user, :tournament => @tournament}
      end

      if @old_admins.count > 0
        @old_admins.each do |admin|
        	user = User.find(admin)
          TournamentAdmin.where(user_id: user, tournament_id: @tournament).destroy_all
        end
      end

      if TournamentAdmin.create(@create_admins)
     		redirect_to admin_root_path
     		flash[:notice] = "Tournament Admins Successfully Updated"
      else
      	# @success = true
        admin_edit_tournament_path(@tournament)
				flash[:notice] = "Failed to Update Tournament Admins"
      end

    else

			if @tournament.update_attributes(params[:tournament])
	     	redirect_to admin_root_path
	     	flash[:notice] = "Tournament Successfully Updated"
	    else
	      	redirect_to admin_edit_tournament_path(@tournament)
	      	flash[:error] = "Failed to Update Tournament"
	    end

	  end
  end

  def rankings
    @tournament = Tournament.find(params[:tournament_id])
    enforce_tournament_admin_tournament(@tournament)
    @teams = TournamentTeam.in_tournament(@tournament).ranking
    @ranks = []

    for i in 1..@teams.length
      @ranks << i
    end
  end

  def update_rankings
    @tournament = Tournament.find(params[:tournament_id])
    enforce_tournament_admin_tournament(@tournament)

    if TournamentTeam.update(params[:teams].keys, params[:teams].values)
      redirect_to schedule_admin_tournaments_path(:tournament_id => @tournament.id)
      flash[:notice] = "ranks successfully updated."
    else
      render "rankings"
      flash[:alert] = "unable to update ranks"
    end
  end

  def schedule
    @match = Match.new
    @tournament = Tournament.find(params[:tournament_id])
    enforce_tournament_admin_tournament(@tournament)
    @teams = TournamentTeam.in_tournament(@tournament).order(:rank)
    @team_names = @teams.map do |tourny_team|
      [tourny_team.team.name, tourny_team.id]
    end

    @matchups = @tournament.scheduler
  end

  def create_schedule
    @tournament = Tournament.find(params[:tournament_id])
    enforce_tournament_admin_tournament(@tournament)
    @matches = params[:matches]
    match_date = date_converter(params)
    if schedule_creater(@matches, params, match_date)
      @tournament.current_week_num = params[:week].to_i
      if @tournament.save
        flash[:notice] = "matches successfully created!"
        redirect_to admin_root_path
      end
    else
      flash[:alert] = "failed to save schedule"
      redirect_to :back
    end

  end

  def deactivate
    @tournament = Tournament.find(params[:tournament_id])
    enforce_tournament_admin_tournament(@tournament)
    @tournament.active = false
    if @tournament.save
      flash[:notice] = "Tournament deactivated"
      redirect_to admin_root_path
    else
      flash[:alert] = "Failed to deactivate tournament"
      render :edit
    end
  end

  def activate
    @tournament = Tournament.find(params[:tournament_id])
    enforce_tournament_admin_tournament(@tournament)
    @tournament.active = true
    if @tournament.save
      flash[:notice] = "Tournament activated"
      redirect_to admin_root_path
    else
      flash[:alert] = "Failed to activate tournament"
      render :edit
    end
  end

  def start_bracket
    @tournament = Tournament.find(params[:tournament_id])
    enforce_tournament_admin_tournament(@tournament)
    t = Challonge::Tournament.find(@tournament.challonge_id)
    @tournament.tournament_teams.shuffle.each do |team|
      x = Challonge::Participant.create(:name => team.team.name + team.team.tag, :tournament => t)
      team.challonge_id = x.id
      if not team.save
        flash[:alert] = "Could not create tournament partipants..."
        redirect_to admin_root_path
      end
    end
    if t.start!
      t.reload
      @tournament.challonge_state = t.state
      if @tournament.save
        flash[:notice] = "Bracket started! Now generate matches."
        redirect_to admin_tournament_bracket_matches_path(:tournament_id => @tournament.id)
      else
        flash[:alert] = "Tournament failed to properly update."
        redirect_to admin_root_path
      end
    else
      flash[:alert] = "Failed to start bracket."
      redirect_to admin_root_path
    end
  end

  def bracket_matches
    @match = Match.new
    @tournament = Tournament.find(params[:tournament_id])
    enforce_tournament_admin_tournament(@tournament)
    @teams = TournamentTeam.in_tournament(@tournament)
    @team_names = @teams.map do |tourny_team|
      [tourny_team.team.name, tourny_team.id]
    end
    @matchups = @tournament.get_challonge_matches
  end

  def generate_bracket_matches
    @tournament = Tournament.find(params[:tournament_id])
    enforce_tournament_admin_tournament(@tournament)
    @matches = params[:matches]
    match_date = date_converter(params)
    if schedule_creater(@matches, params, match_date)
      flash[:notice] = "bracket matches successfully created!"
      redirect_to admin_root_path
    else
      flash[:alert] = "failed to generate bracket matches"
      redirect_to :back
    end
  end

  def bracket_results
    @tournament = Tournament.find(params[:tournament_id])
    enforce_tournament_admin_tournament(@tournament)
    @matches = @tournament.matches.where(challonge_updated: false)
  end

  def update_bracket
    @tournament = Tournament.find(params[:tournament_id])
    enforce_tournament_admin_tournament(@tournament)
    @matches = @tournament.matches.where(challonge_updated: false)
    @challonge_matches = Challonge::Tournament.find(@tournament.challonge_id).matches
    @challonge_matches.each do |m|
      match = @matches.where(challonge_id: m.id )
      unless match.empty?
        match = match[0]
        m.scores_csv = "#{match.home_score}-#{match.away_score}"
        if match.home_team_id == match.winner_id
          m.winner_id = match.home_team.challonge_id
        elsif match.away_team_id == match.winner_id
          m.winner_id = match.away_team.challonge_id
        end
        match.challonge_updated = true
        if not m.save
          flash[:alert] = m.errors.full_messages
        else
          match.save
        end
      end
    end
    flash[:notice] = "Bracket updated! New matches may be available to generate."
    redirect_to root_path
  end

  def playoffs
    @tournament = Tournament.find(params[:tournament_id])
    enforce_tournament_admin_tournament(@tournament)
    @teams = @tournament.get_tournament_team_names_by_rank
    if @teams.empty?
      flash[:alert] = "You can't start playoffs with no teams!"
      redirect_to :back
    end
    gon.teams = @teams
  end

  def generate_playoff_bracket
    @tournament = Tournament.find(params[:tournament_id])
    enforce_tournament_admin_tournament(@tournament)
    @bracket_size = @tournament.bracket_size = params[:bracket_size].to_i
    @teams = @tournament.tournament_teams.ranking

    # if @teams.first(@bracket_size).include?(nil) || @teams.first(@bracket_size).include?('undefined')
    #   flash[:alert] = "Invalid bracket size. Likely too large."
    #   redirect_to :back
    # end

    #create the bracket
    t = Challonge::Tournament.new
    t.name = @tournament.name
    t.subdomain = "ftwgamingleague"
    t.tournament_type = "single elimination"
    t.url = Devise.friendly_token.first(5)
    if t.save
      t.reload

      @tournament.challonge_url = t.url
      @tournament.challonge_img = t.live_image_url
      @tournament.challonge_id = t.id
      if @tournament.save
        #create bracket participants and start the bracket, set tournament.playoffs to true
        @teams.first(@bracket_size).each do |team|
          x = Challonge::Participant.create(:name => team.team.name + team.team.tag, :tournament => t)
          team.challonge_id = x.id
          if not team.save
            flash[:alert] = "Could not create tournament partipants..."
            redirect_to :back
          end
        end

        if t.start!
          t.reload
          @tournament.challonge_state = t.state
          @tournament.playoffs = true
          if @tournament.save
            flash[:notice] = "Playoff bracket successfully created! Now go generate the matches..."
            redirect_to admin_root_path
          else
            flash[:alert] = "Tournament failed to properly update."
            redirect_to :back
          end
        else
          flash[:alert] = "Failed to start bracket."
          redirect_to :back
        end
      end
    else
      flash[:alert] = t.errors.full_messages
      redirect_to :back
    end
  end

  private

  def date_converter(params)
    match_date = DateTime.civil(
      params[:match_date]["date(1i)"].to_i,
      params[:match_date]["date(2i)"].to_i,
      params[:match_date]["date(3i)"].to_i,
      params[:match_date]["date(4i)"].to_i,
      params[:match_date]["date(5i)"].to_i)
  end

  def schedule_creater(matches, params, match_date)
    Match.transaction do
      matches.each do |match|
        Match.create(home_team_id: match["home_team_id"].to_i,
          away_team_id: match["away_team_id"].to_i,
          tournament_id: params[:tournament_id].to_i,
          week_num: params[:week].to_i,
          match_date: match_date,
          challonge_id: match["challonge_id"].to_i)
      end
    end
  end

  def enforce_tournament_admin_tournament(tourny)
    if current_user.is_tournament_admin? && !current_user.has_role?(:admin)
      tournaments = current_user.admin_tournaments
      if !tournaments.include?(tourny)
        flash[:alert] = "You don't have sufficient permissions to do that."
        redirect_to admin_root_path
      end
    end
  end

end
