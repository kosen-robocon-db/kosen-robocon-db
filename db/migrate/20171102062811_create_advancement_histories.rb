class CreateAdvancementHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :advancement_histories do |t|
      t.integer :contest_nth,             null: false
      t.integer :region_code,             null: false
      t.integer :campus_code,             null: false
      t.integer :robot_code,              null: false
      t.integer :advancement_case,        null: false
      t.boolean :decline, default: false, null: false
      t.string  :memo

      t.timestamps
    end
    add_index :advancement_histories, [:robot_code], unique: true
  end

end
