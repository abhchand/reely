class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.timestamps null: false
      t.string :synthetic_id, index: { unique: true }, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :password, null: false
      t.string :password_salt, null: false
    end

    add_index :users, :email, unique: true
  end
end
