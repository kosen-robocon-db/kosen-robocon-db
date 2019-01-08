class AddColumnToRobot < ActiveRecord::Migration[5.2]
  def change
    add_column :robots, :name_alias, :string
    add_column :robots, :kana_alias, :string
  end
end
