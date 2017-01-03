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

ActiveRecord::Schema.define(version: 20170103122126) do

  create_table "campuses", force: :cascade do |t|
    t.integer  "region_id",    null: false
    t.string   "name",         null: false
    t.string   "abbreviation", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["region_id"], name: "index_campuses_on_region_id"
  end

  create_table "contests", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "nth",        null: false
    t.integer  "year",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "school"
    t.integer  "campus"
    t.integer  "team"
    t.index ["nth"], name: "index_contests_on_nth", unique: true
    t.index ["year"], name: "index_contests_on_year"
  end

  create_table "regions", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "robots", force: :cascade do |t|
    t.integer  "contest_id", null: false
    t.integer  "campus_id",  null: false
    t.string   "name"
    t.string   "kana"
    t.string   "team"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campus_id"], name: "index_robots_on_campus_id"
    t.index ["contest_id", "campus_id"], name: "index_robots_on_contest_id_and_campus_id"
    t.index ["contest_id"], name: "index_robots_on_contest_id"
  end

end
