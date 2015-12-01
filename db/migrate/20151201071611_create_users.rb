class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :firstname
      t.string :surname
      t.string :email, null: false
      t.string :password, null: false
      t.string :token
      t.datetime :timeout
      t.timestamps null: false
    end
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end