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

ActiveRecord::Schema[7.0].define(version: 2022_07_07_070625) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["user_id"], name: "index_dogs_on_user_id"
  end

  create_table "entries", force: :cascade do |t|
    t.bigint "dog_id", null: false
    t.bigint "registration_number_id", null: false
    t.datetime "entry_at", null: false
    t.datetime "exit_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dog_id", "registration_number_id", "entry_at"], name: "registration_dog_entry_time_index", unique: true
    t.index ["dog_id"], name: "index_entries_on_dog_id"
    t.index ["registration_number_id"], name: "index_entries_on_registration_number_id"
  end

  create_table "registration_numbers", force: :cascade do |t|
    t.integer "dogrun_place", null: false
    t.string "registration_number", null: false
    t.bigint "dog_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dog_id"], name: "index_registration_numbers_on_dog_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.boolean "enable_notification", default: false, null: false
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
    t.index ["unlock_token"], name: "index_users_on_unlock_token"
  end

  add_foreign_key "dogs", "users"
  add_foreign_key "entries", "dogs"
  add_foreign_key "entries", "registration_numbers"
  add_foreign_key "registration_numbers", "dogs"
end
