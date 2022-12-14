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

ActiveRecord::Schema.define(version: 2022_11_04_022735) do

  create_table "histories", force: :cascade do |t|
    t.integer "region_id"
    t.date "date"
    t.string "time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_yesterday", default: false, null: false
    t.index ["region_id"], name: "index_histories_on_region_id"
  end

  create_table "itches", force: :cascade do |t|
    t.integer "region_id"
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["region_id"], name: "index_itches_on_region_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.integer "interval"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "morning", default: false, null: false
    t.boolean "noon", default: false, null: false
    t.boolean "night", default: false, null: false
    t.string "medicin"
    t.date "last_morning"
    t.date "last_noon"
    t.date "last_night"
    t.boolean "is_proactive", default: false, null: false
    t.date "proactive_start"
    t.integer "proactive_interval"
    t.index ["user_id"], name: "index_regions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "meta"
    t.string "token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "histories", "regions"
  add_foreign_key "itches", "regions"
  add_foreign_key "regions", "users"
end
