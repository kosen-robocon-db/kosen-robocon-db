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

ActiveRecord::Schema.define(version: 20171102052238) do

  create_table "advancements", force: :cascade do |t|
    t.integer  "case",        null: false
    t.string   "case_name",   null: false
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["case"], name: "index_advancements_on_case", unique: true
  end

  create_table "campus_histories", force: :cascade do |t|
    t.integer  "campus_code",  null: false
    t.integer  "region_code",  null: false
    t.integer  "begin",        null: false
    t.integer  "end",          null: false
    t.string   "name",         null: false
    t.string   "abbreviation", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["campus_code"], name: "index_campus_histories_on_campus_code"
  end

  create_table "campuses", force: :cascade do |t|
    t.integer  "code",                                 null: false
    t.integer  "region_code",                          null: false
    t.string   "name",                                 null: false
    t.string   "abbreviation",                         null: false
    t.decimal  "latitude",     precision: 9, scale: 6
    t.decimal  "longitude",    precision: 9, scale: 6
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.index ["code"], name: "index_campuses_on_code", unique: true
    t.index ["region_code"], name: "index_campuses_on_region_code"
  end

  create_table "contest_entries", force: :cascade do |t|
    t.integer  "contest_nth", null: false
    t.integer  "school"
    t.integer  "campus"
    t.integer  "team"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["contest_nth"], name: "index_contest_entries_on_contest_nth", unique: true
  end

  create_table "contests", force: :cascade do |t|
    t.integer  "nth",        null: false
    t.integer  "year",       null: false
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nth"], name: "index_contests_on_nth", unique: true
    t.index ["year"], name: "index_contests_on_year"
  end

  create_table "game_details", force: :cascade do |t|
    t.integer  "game_code",              null: false
    t.integer  "number",     default: 1, null: false
    t.text     "properties"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["game_code", "number"], name: "index_game_details_on_game_code_and_number"
  end

  create_table "games", force: :cascade do |t|
    t.integer  "code",              null: false
    t.integer  "contest_nth",       null: false
    t.integer  "region_code",       null: false
    t.integer  "round",             null: false
    t.integer  "game",              null: false
    t.integer  "left_robot_code",   null: false
    t.integer  "right_robot_code",  null: false
    t.integer  "winner_robot_code", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["code"], name: "index_games_on_code", unique: true
    t.index ["contest_nth"], name: "index_games_on_contest_nth"
    t.index ["region_code"], name: "index_games_on_region_code"
  end

  create_table "prize_histories", force: :cascade do |t|
    t.integer  "contest_nth", null: false
    t.integer  "region_code", null: false
    t.integer  "campus_code", null: false
    t.integer  "robot_code",  null: false
    t.integer  "prize_kind",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "prizes", force: :cascade do |t|
    t.integer  "kind",       null: false
    t.string   "name",       null: false
    t.string   "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kind"], name: "index_prizes_on_kind", unique: true
  end

  create_table "regions", force: :cascade do |t|
    t.integer  "code",       null: false
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_regions_on_code", unique: true
  end

  create_table "robot_conditions", force: :cascade do |t|
    t.integer  "robot_code",                        null: false
    t.boolean  "fully_operational", default: false, null: false
    t.boolean  "restoration",       default: false, null: false
    t.string   "memo"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["robot_code"], name: "index_robot_conditions_on_robot_code", unique: true
  end

  create_table "robots", force: :cascade do |t|
    t.integer  "code",        null: false
    t.integer  "contest_nth", null: false
    t.integer  "campus_code", null: false
    t.string   "team"
    t.string   "name",        null: false
    t.string   "kana"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["campus_code"], name: "index_robots_on_campus_code"
    t.index ["code"], name: "index_robots_on_code", unique: true
    t.index ["contest_nth", "campus_code"], name: "index_robots_on_contest_nth_and_campus_code"
    t.index ["contest_nth"], name: "index_robots_on_contest_nth"
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "nickname",                            null: false
    t.string   "name",                                null: false
    t.string   "image"
    t.string   "description"
    t.boolean  "approved",            default: false, null: false
    t.datetime "remember_created_at"
    t.string   "remember_token"
    t.integer  "sign_in_count",       default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  end

end
