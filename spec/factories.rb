FactoryGirl.define do
  
  factory :team do
    sequence(:name) {|n| "foo#{n}"}
    tag '[bar]'
  end

  factory :membership do
    team
    user
    role 'member'
    active false
  end

  factory :tournament do
    name "FTW Team Survivor"
    description "Season 1"
    rules "Don't cheat"
  end

  factory :tournament_team do
    team
    tournament
  end
end
