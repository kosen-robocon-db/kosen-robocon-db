class AddColumnToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :reasons_for_victory, :integer
  end
end
