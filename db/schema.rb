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

ActiveRecord::Schema.define(version: 20170224021923) do

  create_table "campus_histories", force: :cascade do |t|
    t.integer  "campus_code"
    t.integer  "begin",        null: false
    t.integer  "end",          null: false
    t.string   "name",         null: false
    t.string   "abbreviation", null: false
    t.integer  "region_code"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "campuses", force: :cascade do |t|
    t.string   "name",                                 null: false
    t.string   "abbreviation",                         null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "code"
    t.decimal  "latitude",     precision: 9, scale: 6
    t.decimal  "longitude",    precision: 9, scale: 6
    t.integer  "region_code",                          null: false
    t.index ["region_code"], name: "index_campuses_on_region_code"
  end

  create_table "contest_entries", force: :cascade do |t|
    t.integer  "school"
    t.integer  "campus"
    t.integer  "team"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "nth"
    t.index ["nth"], name: "index_contest_entries_on_nth", unique: true
  end

  create_table "contests", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "nth",        null: false
    t.integer  "year",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nth"], name: "index_contests_on_nth", unique: true
    t.index ["year"], name: "index_contests_on_year"
  end

  create_table "regions", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "code",       null: false
    t.index ["code"], name: "index_regions_on_code", unique: true
  end

  create_table "robots", force: :cascade do |t|
    t.integer  "contest_id", null: false
    t.integer  "campus_id",  null: false
    t.string   "name"
    t.string   "kana"
    t.string   "team"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "code",       null: false
    t.index ["campus_id"], name: "index_robots_on_campus_id"
    t.index ["code"], name: "index_robots_on_code", unique: true
    t.index ["contest_id", "campus_id"], name: "index_robots_on_contest_id_and_campus_id"
    t.index ["contest_id"], name: "index_robots_on_contest_id"
  end

end
