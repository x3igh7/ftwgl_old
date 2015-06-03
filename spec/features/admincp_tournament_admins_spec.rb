require 'spec_helper'

describe "tournament admins", :focus => true do
  let!(:tournament1) {FactoryGirl.create(:tournament)}
  let!(:tournament2) {FactoryGirl.create(:tournament)}
  let!(:admin) {FactoryGirl.create(:user)}
  let!(:user) {FactoryGirl.create(:user)}
  let!(:user2) {FactoryGirl.create(:user)}
  let!(:tourny_admin) {FactoryGirl.create(:tournament_admin, user: user2, tournament: tournament1)}
  let!(:team) {FactoryGirl.create(:team)}
  let!(:tournament_team) { FactoryGirl.create(:tournament_team, team: team, tournament: tournament1, wins: 15, losses: 5) }
  let!(:news) { FactoryGirl.create(:news, newsable_type: "Tournament", newsable_id: tournament1.id, user: admin) }

  before do
    admin.roles = :admin
    admin.save
  end

	it 'can be managed in the admincp', :js => true do
		sign_in_as admin
		prev = TournamentAdmin.all.count
		manage
		click_on "edit-tourny-#{tournament1.id}"
  	page.find(:css, "#s2id_autogen1").set "#{user.username}"
    sleep 2
  	page.find(:css, '.select2-result-label').click
  	click_on "tournament-admins-update"
		expect(TournamentAdmin.all.count).to eq(prev + 1)
	end

	it 'can see tournaments they are assigned to', :js => true do
		sign_in_as user2
		manage
		expect(page).to have_content(tournament1.name)
		expect(page).to_not have_content(tournament2.name)
	end

	it 'can access tournaments they are assigned to', :js => true do
		sign_in_as user2
		manage
		click_on "edit-tourny-#{tournament1.id}"
		expect(page).to have_content('edit tournament')
	end

	it 'can edit teams that participate in tournament they are assigned to', :js => true do
		sign_in_as user2
		visit admin_root_path
	  find('#manage-teams').click

		click_on "manage-#{team.name}"
		expect(page).to have_content('edit team profile')
	end

	it 'can edit news in tournaments they are assigned to', :js => true do
		sign_in_as user2
		visit admin_root_path
	  find('#manage-news').click

    click_on "edit-news-#{news.id}"
		expect(page).to have_content("Headline")
	end
end

def manage
  visit admin_root_path
  find('#manage-tournaments').click
end
