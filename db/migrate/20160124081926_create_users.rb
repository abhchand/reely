class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.timestamps null: false
      t.string :synthetic_id, index: { unique: true }, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false

      # Devise: Database authenticatable
      t.string :email,              null: false
      t.string :encrypted_password

      # Devise: Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      # Devise: Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      # Devise: Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      # Devise: Omniauthable
      t.string :provider
      t.string :uid
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :uid,                  unique: true
  end
end
