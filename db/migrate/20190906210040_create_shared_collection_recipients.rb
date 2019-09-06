class CreateSharedCollectionRecipients < ActiveRecord::Migration[5.2]
  def change
    create_table :shared_collection_recipients do |t|
      t.references :collection, foreign_key: true, null: false, index: false
      t.references :recipient, references: :users, null: false, index: false
    end

    # Can't use `foreign_key:` option when using `references:` option
    # Add it explicitly
    add_foreign_key :shared_collection_recipients, :users, column: :recipient_id

    # - Add two-way compound indexes for searching in either direction
    # - Override name since default name is greater than 63 character
    # - Add unique constraint on one of the two indexes
    # psql limit
    add_index :shared_collection_recipients, [:collection_id, :recipient_id], name: "index_shared_collection_recipients_on_collection_and_recipient", unique: true
    add_index :shared_collection_recipients, [:recipient_id, :collection_id], name: "index_shared_collection_recipients_on_recipient_and_collection"
  end
end
