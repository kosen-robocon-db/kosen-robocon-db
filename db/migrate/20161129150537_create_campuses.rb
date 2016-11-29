class CreateCampuses < ActiveRecord::Migration[5.0]
  def change
    create_table :campuses do |t|
      t.references :region, index: true, foreign_key: true, null: false
      t.string :name, null: false
      t.string :abbreviation, null: false

      t.timestamps
    end
  end
end
