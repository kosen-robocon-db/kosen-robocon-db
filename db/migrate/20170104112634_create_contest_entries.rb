class CreateContestEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :contest_entries do |t|
      t.belongs_to :contest
      t.integer :school
      t.integer :campus
      t.integer :team
      t.timestamps
    end
  end
end
