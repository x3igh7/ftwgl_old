require 'spec_helper'

describe "Navigation" do
  context "nav bar" do

    before :each do
      visit root_path
    end

    it "links to the home page" do
      page.find('.nav').click_on "home"
      expect(current_path).to eq(root_path)
    end
  
    it "links to memebers index" do
      page.find('.nav').click_on "members"
      expect(current_path).to eq(user_index_path)
    end
  
    it "links to teams index" do
      page.find('.nav').click_on "teams"
      expect(current_path).to eq(teams_path)
    end
  
    it "links to tournaments index" do
      page.find('.nav').click_on "tournaments"
      expect(current_path).to eq(tournaments_path)
    end

  end
end
