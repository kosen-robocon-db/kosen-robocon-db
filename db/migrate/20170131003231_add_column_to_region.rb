class AddColumnToRegion < ActiveRecord::Migration[5.0]
  def change
    add_column    :regions, :code, :integer
    change_column :regions, :code, :integer, null: false # add_columnでnull: falseをするとエラーが出るので分けた
    add_index     :regions, :code,  unique: true
  end
end
