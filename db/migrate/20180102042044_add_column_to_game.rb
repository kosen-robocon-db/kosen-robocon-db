class AddColumnToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :reasons_for_victory, :integer
  end
end
