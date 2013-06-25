require 'spec_helper'

describe 'creating a team' do
  
  context 'as a user' do
    let(:user) { FactoryGirl.create(:user) }

    before :each do
      sign_in_as user
    end

    it 'shows the team page after successful creation' do
      create_team

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
      create_team

      team = Team.first
      team.owners.should include(user)
    end

    it 'can navigate to their team page' do
      team = FactoryGirl.create(:team)
      FactoryGirl.create(:membership, team: team, user: user)

      visit root_path
      
      click_on "foo[bar]"

      expect(current_path).to eq(team_path(team))
    end
  end

  def create_team
    visit new_team_path
    fill_in 'Name', with: 'foobar'
    fill_in 'Tag', with: '[TAG]'
    click_button 'Create Team'
  end
end
