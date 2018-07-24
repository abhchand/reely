# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160425013204) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "photos", force: :cascade do |t|
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "synthetic_id",            null: false
    t.integer  "owner_id",                null: false
    t.string   "source_file_name",        null: false
    t.string   "source_content_type",     null: false
    t.integer  "source_file_size",        null: false
    t.datetime "source_updated_at",       null: false
    t.string   "source_file_fingerprint"
    t.datetime "taken_at"
    t.integer  "width"
    t.integer  "height"
    t.decimal  "latitude"
    t.decimal  "longitude"
  end

  add_index "photos", ["owner_id"], name: "index_photos_on_owner_id", using: :btree
  add_index "photos", ["source_file_fingerprint"], name: "index_photos_on_source_file_fingerprint", using: :btree
  add_index "photos", ["synthetic_id"], name: "index_photos_on_synthetic_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "first_name",          null: false
    t.string   "last_name",           null: false
    t.string   "email",               null: false
    t.string   "password",            null: false
    t.string   "password_salt",       null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "photos", "users", column: "owner_id"
end
