class CreateAdvancements < ActiveRecord::Migration[5.0]
  def change
    create_table :advancements do |t|
      t.integer :contest_nth, null: false
      t.integer :region_code, null: false
      t.integer :campus_code, null: false
      t.integer :robot_code,  null: false
      t.integer :reason_code, null: false
      t.boolean :decline,     null: false, defaut: false
      t.string  :memo

      t.timestamps
    end
    add_index :advancements, [:robot_code], unique: true
  end
end
