class AddColumnToRobot2 < ActiveRecord::Migration[5.2]
  def change
    add_column :robots, :memo, :string
  end
end
