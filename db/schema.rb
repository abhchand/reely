# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_22_041320) do

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
    t.string "share_id", null: false
    t.integer "owner_id", null: false
    t.string "name", null: false
    t.jsonb "sharing_config", default: {}, null: false
    t.index ["owner_id"], name: "index_collections_on_owner_id"
    t.index ["share_id"], name: "index_collections_on_share_id", unique: true
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

  create_table "product_feedbacks", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.string "body", null: false
    t.index ["user_id"], name: "index_product_feedbacks_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "shared_collection_recipients", force: :cascade do |t|
    t.bigint "collection_id", null: false
    t.bigint "recipient_id", null: false
    t.index ["collection_id", "recipient_id"], name: "index_shared_collection_recipients_on_collection_and_recipient", unique: true
    t.index ["recipient_id", "collection_id"], name: "index_shared_collection_recipients_on_recipient_and_collection"
  end

  create_table "user_invitations", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", null: false
    t.bigint "inviter_id", null: false
    t.bigint "invitee_id"
    t.index ["email"], name: "index_user_invitations_on_email", unique: true
    t.index ["invitee_id"], name: "index_user_invitations_on_invitee_id", unique: true
    t.index ["inviter_id"], name: "index_user_invitations_on_inviter_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "synthetic_id", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "encrypted_password"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "provider"
    t.string "uid"
    t.datetime "deactivated_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["synthetic_id"], name: "index_users_on_synthetic_id", unique: true
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "collections", "users", column: "owner_id"
  add_foreign_key "photo_collections", "collections"
  add_foreign_key "photo_collections", "photos"
  add_foreign_key "photos", "users", column: "owner_id"
  add_foreign_key "product_feedbacks", "users"
  add_foreign_key "shared_collection_recipients", "collections"
  add_foreign_key "shared_collection_recipients", "users", column: "recipient_id"
  add_foreign_key "user_invitations", "users", column: "invitee_id"
  add_foreign_key "user_invitations", "users", column: "inviter_id"
end
