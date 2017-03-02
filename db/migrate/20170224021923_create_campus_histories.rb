class CreateCampusHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :campus_histories do |t|
      # temporalily rewriting
      #t.integer :campus_code, foreign_key: true, null: false
      t.integer :campus_code
      #t.integer :region_code, foreign_key: true
      t.integer :region_code
      t.integer :begin, null: false
      t.integer :end, null: false
      t.string :name, null: false
      t.string :abbreviation, null: false

      t.timestamps
    end
    add_index :campus_histories, :campus_code
  end
end
