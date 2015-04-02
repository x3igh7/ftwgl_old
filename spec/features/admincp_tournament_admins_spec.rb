require 'spec_helper'

describe "tournament admins" do
  let!(:tournament1) {FactoryGirl.create(:tournament)}
  let!(:tournament2) {FactoryGirl.create(:tournament)}
  let!(:admin) {FactoryGirl.create(:user)}
  let!(:user) {FactoryGirl.create(:user)}
  let!(:tourny_admin) {FactoryGirl.create(:tournament_admin, user: user, tournament: tournament1)}

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
		sign_in_as tourny_admin
		manage
		expect(page).to have_content(tournament1.name)
		expect(page).to_not have_content(tournament2.name)
	end

	it 'can access tournaments they are assigned to', :js => true do
		sign_in_as tourny_admin
		manage
		click_on "edit-tourny-#{tournament1.id}"
		expect(page).to have_content(tournament1.name)
	end

	it 'can post news to tournaments they are assigned to', :js => true do
		sign_in_as tourny_admin
		manage
		click_on "news stuff"
		pending "rest of the stuff"
	end

	it 'can edit teams that participate in tournament they are assigned to', :js => true do
		sign_in_as tourny_admin
		manage
		click_on "teams stuff"
		pending "rest of the stuff"
	end
end

def manage
  visit admin_root_path
  find('#manage-tournaments').click
end
