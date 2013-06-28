require 'spec_helper'

describe "Navigation" do
  context "nav bar" do

    before :each do
      visit root_path
    end

    it "brand links to the home page" do
      page.find('.navbar-inner').click_on "FTW"
      expect(current_path).to eq(root_path)
    end

    it "links to the home page" do
      page.find('.navbar-inner').click_on "Home"
      expect(current_path).to eq(root_path)
    end
  
    it "links to memebers index" do
      page.find('.navbar-inner').click_on "Members"
      expect(current_path).to eq(user_index_path)
    end
  
    it "links to teams index" do
      page.find('.navbar-inner').click_on "Teams"
      expect(current_path).to eq(teams_path)
    end
  
    it "links to tournaments index" do
      page.find('.navbar-inner').click_on "Tournaments"
      expect(current_path).to eq(tournaments_path)
    end

  end
end
