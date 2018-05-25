class CreateAdvancements < ActiveRecord::Migration[5.2]
  def change
    create_table :advancements do |t|
      t.integer :case,        null: false
      t.string  :case_name,   null: false
      t.string  :description

      t.timestamps
    end
    add_index :advancements, [:case], unique: true
  end
end
