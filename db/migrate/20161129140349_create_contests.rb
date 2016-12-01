class CreateContests < ActiveRecord::Migration[5.0]
  def change
    create_table :contests do |t|
      t.string  :name, null: false
      t.integer :nth,  null: false
      t.integer :year, null: false

      t.timestamps
    end
    add_index :contests, :nth,  unique: true
    add_index :contests, :year
  end
end
