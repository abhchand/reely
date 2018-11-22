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

ActiveRecord::Schema.define(version: 2018_07_24_022211) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.integer "owner_id", null: false
    t.string "source_file_name", null: false
    t.string "source_content_type", null: false
    t.bigint "source_file_size", null: false
    t.datetime "source_updated_at", null: false
    t.string "source_file_fingerprint"
    t.datetime "taken_at", null: false
    t.integer "width", null: false
    t.integer "height", null: false
    t.decimal "latitude"
    t.decimal "longitude"
    t.index ["owner_id"], name: "index_photos_on_owner_id"
    t.index ["source_file_fingerprint"], name: "index_photos_on_source_file_fingerprint"
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
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.bigint "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "collections", "users", column: "owner_id"
  add_foreign_key "photo_collections", "collections"
  add_foreign_key "photo_collections", "photos"
  add_foreign_key "photos", "users", column: "owner_id"
end
