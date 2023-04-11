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

ActiveRecord::Schema[7.0].define(version: 2023_04_10_034218) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "morning_activity_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "start_time_plan_id", null: false
    t.datetime "started_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["start_time_plan_id"], name: "index_morning_activity_logs_on_start_time_plan_id"
    t.index ["user_id"], name: "index_morning_activity_logs_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "start_time_plans", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "start_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_start_time_plans_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "morning_activity_logs", "start_time_plans", on_delete: :cascade
  add_foreign_key "morning_activity_logs", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "start_time_plans", "users"
end
