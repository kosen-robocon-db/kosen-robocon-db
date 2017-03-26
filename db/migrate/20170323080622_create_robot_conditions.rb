class CreateRobotConditions < ActiveRecord::Migration[5.0]
  def change
    create_table :robot_conditions do |t|
      t.integer :robot_code,                        null: false
      # t.boolean :existence # 現存 ・・・ レコードが存在しているだけで現存とする
      t.boolean :fully_operational, default: false, null: false # 完全作動
      t.boolean :restoration      , default: false, null: false # 復元
      t.string  :memo
      t.timestamps
      t.index ["robot_code"], name: "index_robot_conditions_on_robot_code", unique: true
    end
  end
end
