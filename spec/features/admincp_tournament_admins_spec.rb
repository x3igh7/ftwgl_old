require 'spec_helper'

describe "tournament admins" do
  let!(:tournament1) {FactoryGirl.create(:tournament)}
  let!(:admin) {FactoryGirl.create(:user)}
  let!(:user) {FactoryGirl.create(:user)}

  before do
    admin.roles = :admin
    admin.save
    sign_in_as admin
  end

	it 'can be managed in the admincp', :js => true do
		prev = TournamentAdmin.all.count
		manage
		click_on "edit-tourny-#{tournament1.id}"
  	page.find(:css, "#s2id_autogen1").set "#{user.username}"
    sleep 2
  	page.find(:css, '.select2-result-label').click
  	click_on "tournament-admins-update"
		expect(TournamentAdmin.all.count).to eq(prev + 1)
	end

end

def manage
  visit admin_root_path
  find('#manage-tournaments').click
end
