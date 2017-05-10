class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.integer :code, null: false
      t.integer :contest_nth, null: false
      t.integer :region_code, null: false
      t.integer :round, null: false
      t.integer :game, null: false
      t.integer :left_robot_code, null: false
      t.integer :right_robot_code, null: false
      t.integer :winner_robot_code, null: false
      t.timestamps
      t.index ["code"], name: "index_games_on_code", unique: true
      t.index ["contest_nth"], name: "index_games_on_contest_nth"
      t.index ["region_code"], name: "index_games_on_region_code"
    end
  end
end
