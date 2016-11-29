class CreateRobots < ActiveRecord::Migration[5.0]
  def change
    create_table :robots do |t|
      t.references :contest, index: true, foreign_key: true, null: false
      t.references :campus,  index: true, foreign_key: true, null: false
      t.string     :name, null: true
      t.string     :kana, null: true
      t.string     :team, null: true

      t.timestamps
    end
    add_index :robots, [:contest_id, :campus_id]
  end
end