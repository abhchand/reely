# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_03_08_163847) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "collections", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "synthetic_id", null: false
    t.integer "owner_id", null: false
    t.string "name", null: false
    t.index ["owner_id"], name: "index_collections_on_owner_id"
    t.index ["synthetic_id"], name: "index_collections_on_synthetic_id", unique: true
  end

  create_table "photo_collections", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "photo_id", null: false
    t.integer "collection_id", null: false
    t.index ["collection_id", "photo_id"], name: "index_photo_collections_on_collection_id_and_photo_id"
    t.index ["photo_id", "collection_id"], name: "index_photo_collections_on_photo_id_and_collection_id"
  end

  create_table "photos", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "synthetic_id", null: false
    t.string "direct_access_key", null: false
    t.integer "owner_id", null: false
    t.jsonb "exif_data", default: "{}", null: false
    t.datetime "taken_at", null: false
    t.decimal "latitude"
    t.decimal "longitude"
    t.index ["direct_access_key"], name: "index_photos_on_direct_access_key", unique: true
    t.index ["owner_id"], name: "index_photos_on_owner_id"
    t.index ["synthetic_id"], name: "index_photos_on_synthetic_id", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "password", null: false
    t.string "password_salt", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "collections", "users", column: "owner_id"
  add_foreign_key "photo_collections", "collections"
  add_foreign_key "photo_collections", "photos"
  add_foreign_key "photos", "users", column: "owner_id"
end
