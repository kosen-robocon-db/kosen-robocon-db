class CreatePrizeHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :prize_histories do |t|
      t.integer :contest_nth, null: false
      t.integer :region_code, null: false # 全国大会か地区大会かの区別
      t.integer :campus_code, null: false
      t.integer :robot_code,  null: false
      t.integer :prize_kind,  null: false
      t.timestamps
    end
  end
end
