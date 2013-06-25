require 'spec_helper'

describe 'creating a team' do
  
  context 'as a user' do
    let(:user) { FactoryGirl.create(:user) }

    before :each do
      sign_in_as user
    end

    it 'shows the team page after successful creation' do
      visit new_team_path

      fill_in 'Name', with: 'foobar'
      fill_in 'Tag', with: '[TAG]'

      click_button 'Create Team'

      expect(page).to have_content('foobar')
      expect(page).to have_content('[TAG]')

      expect(page).to have_content('Successfully created team') 
    end

    it "shows errors with an invalid team creation" do
      visit new_team_path 

      click_button "Create Team"

      expect(page).to have_content("can't be blank")
    end

    it 'makes the current user the owner' do
      visit new_team_path
      fill_in 'Name', with: 'foobar'
      fill_in 'Tag', with: '[TAG]'
      click_button 'Create Team'

      team = Team.first
      team.owners.should include(user)
    end
  end
end
