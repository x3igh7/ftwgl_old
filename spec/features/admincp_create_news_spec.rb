require 'spec_helper'

describe "News" do
  let!(:tournament1) {FactoryGirl.create(:tournament)}
  let!(:admin) {FactoryGirl.create(:user)}
  let!(:news) { FactoryGirl.create(:news, newsable_type: "General", newsable_id: 0, user: admin)}

  before do
    admin.roles = :admin
    admin.save
    sign_in_as(admin)
  end

  it "can be created by an admin" do
    prev = News.all.count
    news = FactoryGirl.build(:news)
    visit admin_root_path
    click_on "add news"
    select "General", from: "Source"
    fill_in "Headline", with: news.headline
    fill_in "Description", with: news.description
    fill_in "Content", with: news.content
    click_on "Save"
    expect(News.all.count).to eq(prev + 1)
    expect(page).to have_content(news.content)
  end

  it "can be editted by an admin" do
    visit admin_root_path
    click_on "edit-news-#{news.id}"
    fill_in "Headline", with: "new headline"
    click_on "Save"
    editted_news = News.find(news.id)
    expect(editted_news.headline).to eq("new headline")
    expect(editted_news.newsable_type).to eq("General")
  end

  it "can be deleted by an admin" do
    prev = News.count
    visit admin_root_path
    click_on "delete-news-#{news.id}"
    expect(News.count).to eq(prev - 1)
  end

end

def manage
  visit admin_root_path
  find('#manage-tournaments').click
end
