class CreateRoundNames < ActiveRecord::Migration[5.2]
  def change
    create_table :round_names do |t|
      t.integer :contest_nth, null: false
      t.integer :region_code, null: false
      t.integer :round,       null: false
      t.string  :name,        null: false

      t.timestamps
    end
  end
end
