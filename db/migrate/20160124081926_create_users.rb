class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.timestamps null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :password, null: false
      t.string :password_salt, null: false
      t.attachment :avatar
    end

    add_index :users, :email, unique: true
  end
end
