class AddEntryTotalsToContests < ActiveRecord::Migration[5.0]
  def change
    add_column :contests, :school, :integer
    add_column :contests, :campus, :integer
    add_column :contests, :team, :integer
  end
end
