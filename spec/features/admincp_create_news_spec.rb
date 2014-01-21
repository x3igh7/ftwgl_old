require 'spec_helper'

describe "News" do
  let!(:tournament1) {FactoryGirl.create(:tournament)}
  let!(:admin) {FactoryGirl.create(:user)}

  before do
    admin.roles = :admin
    admin.save
    sign_in_as(admin)
  end

  it "can be created by an admin", :focus => true do
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
  end

end

def manage
  visit admin_root_path
  click_button "manage"
end
