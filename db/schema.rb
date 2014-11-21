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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141121034259) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "edges", force: true do |t|
    t.string   "source"
    t.string   "target"
    t.string   "location"
    t.float    "social_distance"
    t.float    "text_distance"
    t.float    "time_distance"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "expressions", force: true do |t|
    t.string  "symbol"
    t.integer "count",          default: 0
    t.string  "raw_text"
    t.string  "processed_text"
  end

  create_table "friendships", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.float    "weight",     default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.string   "from"
    t.string   "id_at_site"
    t.string   "text"
    t.integer  "tiempoenint"
    t.string   "location"
    t.string   "media"
    t.string   "site"
    t.integer  "comments"
    t.integer  "likes"
    t.integer  "repetitions", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationships", force: true do |t|
    t.integer  "expression_id"
    t.integer  "coocurrance_id"
    t.integer  "count",          default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "uid"
    t.string   "provider"
    t.string   "twitter_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
