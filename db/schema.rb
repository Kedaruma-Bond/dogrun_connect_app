# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_12_05_120055) do
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "articles", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_articles_on_post_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dogrun_place_facility_relations", force: :cascade do |t|
    t.bigint "dogrun_place_id", null: false
    t.bigint "facility_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dogrun_place_id"], name: "index_dogrun_place_facility_relations_on_dogrun_place_id"
    t.index ["facility_id"], name: "index_dogrun_place_facility_relations_on_facility_id"
  end

  create_table "dogrun_places", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description", default: ""
    t.string "usage_fee", default: ""
    t.integer "prefecture_code"
    t.string "address", default: ""
    t.string "site_area", default: ""
    t.string "web_site", default: ""
    t.time "opening_time"
    t.time "closing_time"
    t.boolean "closed_flag", default: false
    t.boolean "force_closed", default: false
  end

  create_table "dogs", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "castration", null: false
    t.boolean "public", null: false
    t.string "breed", default: ""
    t.integer "sex"
    t.date "birthday"
    t.integer "weight"
    t.text "owner_comment", default: ""
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date_of_mixed_vaccination"
    t.date "date_of_rabies_vaccination"
    t.string "registration_municipality", default: ""
    t.integer "municipal_registration_number"
    t.integer "registration_prefecture_code"
    t.index ["user_id"], name: "index_dogs_on_user_id"
  end

  create_table "embeds", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.text "identifier", null: false
    t.integer "embed_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_embeds_on_post_id"
  end

  create_table "encount_dogs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "dog_id", null: false
    t.bigint "dogrun_place_id", null: false
    t.integer "color_marker"
    t.text "memo", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "acknowledge", default: false, null: false
    t.index ["dog_id"], name: "index_encount_dogs_on_dog_id"
    t.index ["dogrun_place_id"], name: "index_encount_dogs_on_dogrun_place_id"
    t.index ["user_id"], name: "index_encount_dogs_on_user_id"
  end

  create_table "encounts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "dogrun_place_id", null: false
    t.bigint "user_id", null: false
    t.bigint "dog_id", null: false
    t.bigint "entry_id"
    t.index ["dog_id"], name: "index_encounts_on_dog_id"
    t.index ["dogrun_place_id"], name: "index_encounts_on_dogrun_place_id"
    t.index ["entry_id"], name: "index_encounts_on_entry_id"
    t.index ["user_id"], name: "index_encounts_on_user_id"
  end

  create_table "entries", force: :cascade do |t|
    t.bigint "dog_id", null: false
    t.bigint "registration_number_id", null: false
    t.datetime "entry_at", null: false
    t.datetime "exit_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "entry_digest"
    t.index ["dog_id", "registration_number_id", "entry_at"], name: "registration_dog_entry_time_index", unique: true
    t.index ["dog_id"], name: "index_entries_on_dog_id"
    t.index ["registration_number_id"], name: "index_entries_on_registration_number_id"
  end

  create_table "facilities", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "publish_status", default: false, null: false
    t.bigint "dogrun_place_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "post_type", null: false
    t.datetime "publish_limit"
    t.index ["dogrun_place_id"], name: "index_posts_on_dogrun_place_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "registration_numbers", force: :cascade do |t|
    t.string "registration_number", null: false
    t.bigint "dog_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "dogrun_place_id"
    t.index ["dog_id"], name: "index_registration_numbers_on_dog_id"
    t.index ["dogrun_place_id"], name: "index_registration_numbers_on_dogrun_place_id"
  end

  create_table "sns_accounts", force: :cascade do |t|
    t.string "facebook_id"
    t.string "instagram_id"
    t.string "twitter_id"
    t.bigint "user_id"
    t.bigint "dogrun_place_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dogrun_place_id"], name: "index_sns_accounts_on_dogrun_place_id"
    t.index ["user_id"], name: "index_sns_accounts_on_user_id"
  end

  create_table "staffs", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.boolean "enable_notification", default: false, null: false
    t.bigint "dogrun_place_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dogrun_place_id"], name: "index_staffs_on_dogrun_place_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.boolean "deactivation", default: false, null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.integer "failed_logins_count", default: 0
    t.datetime "lock_expires_at"
    t.string "unlock_token"
    t.integer "role", default: 0, null: false
    t.bigint "dogrun_place_id"
    t.string "facebook_id", default: ""
    t.string "instagram_id", default: ""
    t.string "twitter_id", default: ""
    t.index ["dogrun_place_id"], name: "index_users_on_dogrun_place_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
    t.index ["unlock_token"], name: "index_users_on_unlock_token"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "articles", "posts"
  add_foreign_key "dogrun_place_facility_relations", "dogrun_places"
  add_foreign_key "dogrun_place_facility_relations", "facilities"
  add_foreign_key "dogs", "users"
  add_foreign_key "embeds", "posts"
  add_foreign_key "encount_dogs", "dogrun_places"
  add_foreign_key "encount_dogs", "dogs"
  add_foreign_key "encount_dogs", "users"
  add_foreign_key "encounts", "dogrun_places"
  add_foreign_key "encounts", "dogs"
  add_foreign_key "encounts", "entries"
  add_foreign_key "encounts", "users"
  add_foreign_key "entries", "dogs"
  add_foreign_key "entries", "registration_numbers"
  add_foreign_key "posts", "dogrun_places"
  add_foreign_key "posts", "users"
  add_foreign_key "registration_numbers", "dogrun_places"
  add_foreign_key "registration_numbers", "dogs"
  add_foreign_key "sns_accounts", "dogrun_places"
  add_foreign_key "sns_accounts", "users"
  add_foreign_key "staffs", "dogrun_places"
  add_foreign_key "users", "dogrun_places"
end
