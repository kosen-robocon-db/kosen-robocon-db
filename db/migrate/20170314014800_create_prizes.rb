class CreatePrizes < ActiveRecord::Migration[5.0]
  def change
    create_table :prizes do |t|
      t.integer :kind, null: false
      t.string  :name, null: false
      t.string  :memo
      t.timestamps
      t.index ["kind"], name: "index_prizes_on_kind", unique: true
    end
  end
end
