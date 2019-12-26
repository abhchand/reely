class CreateUserInvitation < ActiveRecord::Migration[6.0]
  def change
    create_table :user_invitations do |t|
      t.timestamps null: false
      t.string :email, null: false, index: { unique: true }
      t.references :inviter, references: :users, index: true, null: false
      t.references :invitee, references: :users, index: { unique: true }, null: true
    end

    # Can't use `foreign_key:` option when using `references:` option
    # Add it explicitly
    add_foreign_key :user_invitations, :users, column: :inviter_id
    add_foreign_key :user_invitations, :users, column: :invitee_id
  end
end
