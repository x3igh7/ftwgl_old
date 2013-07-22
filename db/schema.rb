# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130710191259) do

  create_table "matches", :force => true do |t|
    t.integer  "home_team_id",  :null => false
    t.integer  "away_team_id",  :null => false
    t.integer  "week_num",      :null => false
    t.datetime "match_date",    :null => false
    t.integer  "home_score"
    t.integer  "away_score"
    t.integer  "winner_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "tournament_id", :null => false
  end

  add_index "matches", ["away_team_id"], :name => "index_matches_on_away_team_id"
  add_index "matches", ["home_team_id"], :name => "index_matches_on_home_team_id"
  add_index "matches", ["tournament_id"], :name => "index_matches_on_tournament_id"

  create_table "memberships", :force => true do |t|
    t.integer  "user_id",                          :null => false
    t.integer  "team_id",                          :null => false
    t.string   "role",       :default => "member", :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.boolean  "active",     :default => false,    :null => false
  end

  add_index "memberships", ["team_id"], :name => "index_memberships_on_team_id"
  add_index "memberships", ["user_id", "team_id"], :name => "index_memberships_on_user_id_and_team_id", :unique => true
  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

  create_table "teams", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "tag",        :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tournament_teams", :force => true do |t|
    t.integer  "team_id",                        :null => false
    t.integer  "tournament_id",                  :null => false
    t.integer  "wins",          :default => 0,   :null => false
    t.integer  "losses",        :default => 0,   :null => false
    t.integer  "total_points",  :default => 0,   :null => false
    t.float    "total_diff",    :default => 0.0, :null => false
    t.integer  "rank"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "tournament_teams", ["team_id", "tournament_id"], :name => "index_tournament_teams_on_team_id_and_tournament_id", :unique => true
  add_index "tournament_teams", ["team_id"], :name => "index_tournament_teams_on_team_id"
  add_index "tournament_teams", ["tournament_id"], :name => "index_tournament_teams_on_tournament_id"

  create_table "tournaments", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "description"
    t.text     "rules"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username",               :default => "", :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "avatar_url"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "roles_mask"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
