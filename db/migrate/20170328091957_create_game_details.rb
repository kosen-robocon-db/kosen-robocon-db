class CreateGameDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :game_details do |t|
      t.integer :game_code, null: false
      t.integer :number, default: 1, null: false
      t.text :properties
      t.timestamps
      t.index ["game_code", "number"], name: "index_game_details_on_game_code_and_number"
    end
  end
end
