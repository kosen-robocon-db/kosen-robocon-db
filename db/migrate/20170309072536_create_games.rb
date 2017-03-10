class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.integer :code, null: false
      t.integer :contest_nth, null: false
      t.integer :region_code, null: false
      t.integer :round, null: false
      t.integer :game, null: false
      t.integer :team_left, null: false
      t.integer :team_right, null: false
      t.integer :winner_team, null: false
      t.timestamps
      t.index ["code"], name: "index_Games_on_code", unique: true
      t.index ["contest_nth"], name: "index_Games_on_contest_nth"
      t.index ["region_code"], name: "index_Games_on_region_code"
    end
  end
end
