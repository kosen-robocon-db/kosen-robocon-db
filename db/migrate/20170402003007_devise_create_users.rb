class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid

      t.string :nickname, null: false
      t.string :name, null: false
      t.string :image
      t.string :description

      t.boolean :approved, null: false, default: false

      t.datetime :remember_created_at
      t.string   :remember_token
      t.integer  :sign_in_count, null: false, default: 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps null: false
    end
    add_index :users, [:provider, :uid], unique: true
  end
end