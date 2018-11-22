class CreatePhotos < ActiveRecord::Migration[4.2]
  def change
    create_table :photos do |t|
      t.timestamps null: false
      t.string :synthetic_id, index: { unique: true }, null: false
      t.references :owner, references: :users, index: true, null: false
      t.attachment :source, null: false
      t.string :source_file_fingerprint
      t.datetime :taken_at, null: false
      t.integer :width, null: false
      t.integer :height, null: false
      t.decimal :latitude
      t.decimal :longitude
    end

    # Can't use `foreign_key:` option when using `references:` option
    # Add it explicitly
    add_foreign_key :photos, :users, column: :owner_id

    add_index :photos, [:source_file_fingerprint], unique: false
  end
end
