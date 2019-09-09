class CreateCollections < ActiveRecord::Migration[4.2]
  def change
    create_table :collections do |t|
      t.timestamps null: false
      t.string :synthetic_id, index: { unique: true }, null: false
      t.string :share_id, index: { unique: true }, null: false
      t.references :owner, references: :users, index: true, null: false
      t.string :name, null: false
      t.jsonb :sharing_config, null: false, default: {}
    end

    # Can't use `foreign_key:` option when using `references:` option
    # Add it explicitly
    add_foreign_key :collections, :users, column: :owner_id
  end
end
