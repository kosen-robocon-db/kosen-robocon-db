class AddColumnRegionCodeToCampus < ActiveRecord::Migration[5.0]
  def change
    remove_column :campuses, :region_id,   :integer
    add_column    :campuses, :region_code, :integer
    change_column :campuses, :region_code, :integer, null: false # add_columnでnull: falseをするとエラーが出るので分けた
    add_index     :campuses, :region_code
  end
end
