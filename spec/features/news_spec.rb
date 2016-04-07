require 'spec_helper'

describe "News" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:news) { FactoryGirl.create(:news, newsable_type: "General", newsable_id: 0, user_id: user.id)}
  let!(:tournament) { FactoryGirl.create(:tournament) }
  let!(:tournament_news) { FactoryGirl.create(:news, newsable_type: "Tournament", newsable_id: tournament.id, user_id: user.id) }

  it "will appear on the main page if source is general" do
    visit root_path
    expect(page).to have_content(news.content)
  end

  it "will appear on tournament main page if source is tournament" do
    visit tournament_path(tournament)
    expect(page).to have_content(news.content)
  end

  it "can be commented on" do
    prev = news.comments.count
    sign_in_as(user)
    visit news_path(news)
    fill_in "comment_content", with: "This is a comment!"
    click_on "Submit"
    expect(news.comments.count).to eq(prev + 1)
  end

end
