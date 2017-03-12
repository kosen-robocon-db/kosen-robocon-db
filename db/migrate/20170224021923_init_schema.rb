class InitSchema < ActiveRecord::Migration
  def up

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
      t.integer  "code",         null: false
      t.integer  "region_code",  null: false
      t.string   "name",         null: false
      t.string   "abbreviation", null: false
      t.decimal  "latitude",     precision: 9, scale: 6
      t.decimal  "longitude",    precision: 9, scale: 6
      t.datetime "created_at",   null: false
      t.datetime "updated_at",   null: false
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

    create_table "regions", force: :cascade do |t|
      t.integer  "code",       null: false
      t.string   "name",       null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["code"], name: "index_regions_on_code", unique: true
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
      t.index ["code"], name: "index_robots_on_code", unique: true
      t.index ["contest_nth"], name: "index_robots_on_contest_nth"
      t.index ["campus_code"], name: "index_robots_on_campus_code"
      t.index ["contest_nth", "campus_code"], name: "index_robots_on_contest_nth_and_campus_code"
    end

  end

  def down
    raise ActiveRecord::IrreversibleMigration, "The initial migration is not revertable"
  end
end
