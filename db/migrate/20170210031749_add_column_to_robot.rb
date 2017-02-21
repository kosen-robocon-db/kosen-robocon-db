class AddColumnToRobot < ActiveRecord::Migration[5.0]
  def change
    add_column :robots, :code, :integer
    change_column :robots, :code, :integer, null: false # add_columnでnull: falseをするとエラーが出るので分けた
    add_index :robots, :code, unique: true
  end
end
