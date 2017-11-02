class CreateAdvancements < ActiveRecord::Migration[5.0]
  def change
    create_table :advancements do |t|
      t.integer :case,        null: false
      t.string  :case_name,   null: false
      t.string  :description

      t.timestamps
    end
  end
end
