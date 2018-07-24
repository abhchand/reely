class CreatePhotoCollections < ActiveRecord::Migration
  def change
    create_table :photo_collections do |t|
      t.timestamps null: false
      t.references :photo, foreign_key: true, null: false, index: false
      t.references :collection, foreign_key: true, null: false, index: false
    end

    # Add two-way compound indexes for searching in either direction
    add_index :photo_collections, [:photo_id, :collection_id]
    add_index :photo_collections, [:collection_id, :photo_id]
  end
end
