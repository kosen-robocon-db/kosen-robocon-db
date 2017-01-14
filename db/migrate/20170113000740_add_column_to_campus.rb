class AddColumnToCampus < ActiveRecord::Migration[5.0]
  def change
    add_column :campuses, :code, :integer
    add_column :campuses, :latitude, :decimal, precision: 9, scale: 6
    add_column :campuses, :longitude, :decimal, precision: 9, scale: 6
  end
end
