class CreatePrizes < ActiveRecord::Migration[5.0]
  def change
    create_table :prizes do |t|
      t.integer :contest_nth, null: false
      t.integer :region_code, null: false
      t.integer :campus_code, null: false
      t.integer :robot_code,  null: false
      t.integer :prize_type,  null: false
      t.timestamps
    end
  end
end
