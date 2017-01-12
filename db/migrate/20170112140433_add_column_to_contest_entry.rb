class AddColumnToContestEntry < ActiveRecord::Migration[5.0]
  def change
    remove_column :contest_entries, :contest_id, :integer
    add_column :contest_entries, :nth, :integer
    add_index :contest_entries, :nth,  unique: true
  end
end
