class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.timestamps null: false
      t.attachment :source, null: false
      t.string :source_file_fingerprint
      t.datetime :taken_at
      t.integer :width
      t.integer :height
      t.decimal :latitude
      t.decimal :longitude
    end

    add_index :photos, [:source_file_fingerprint], unique: false
  end
end
