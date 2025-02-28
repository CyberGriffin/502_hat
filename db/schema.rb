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

ActiveRecord::Schema[7.0].define(version: 2025_02_25_050146) do
     create_table "admins", force: :cascade do |t|
          t.string "email", null: false
          t.string "full_name"
          t.string "uid"
          t.string "avatar_url"
          t.datetime "created_at", null: false
          t.datetime "updated_at", null: false
          t.index ["email"], name: "index_admins_on_email", unique: true
     end

     create_table "categories", primary_key: "cat_id", id: :string, force: :cascade do |t|
          t.string "icon"
          t.string "color_code"
          t.datetime "created_at", null: false
          t.datetime "updated_at", null: false
          t.string "name", default: "Unnamed Category", null: false
     end

     create_table "departments", primary_key: "dept_id", id: :string, force: :cascade do |t|
          t.string "name"
          t.datetime "created_at", null: false
          t.datetime "updated_at", null: false
     end

     create_table "inventories", primary_key: "inv_id", force: :cascade do |t|
          t.string "item_id", null: false
          t.date "year_of_purchase"
          t.string "location"
          t.string "condition_of_item"
          t.string "owner_email", null: false
          t.string "user_email"
          t.datetime "created_at", null: false
          t.datetime "updated_at", null: false
          t.string "dept_id"
     end

     create_table "items", primary_key: "item_id", id: :string, force: :cascade do |t|
          t.string "name"
          t.string "description"
          t.string "category_id", null: false
          t.datetime "created_at", null: false
          t.datetime "updated_at", null: false
          t.string "sku"
     end

     create_table "users", primary_key: "email", id: :string, force: :cascade do |t|
          t.string "name"
          t.string "role"
          t.string "dept_id", null: false
          t.boolean "is_white_listed", default: false
          t.date "white_list_end_date"
          t.datetime "created_at", null: false
          t.datetime "updated_at", null: false
          t.string "profile_picture_url"
     end

     add_foreign_key "inventories", "items", primary_key: "item_id"
     add_foreign_key "inventories", "users", column: "owner_email", primary_key: "email"
     add_foreign_key "inventories", "users", column: "user_email", primary_key: "email"
     add_foreign_key "items", "categories", primary_key: "cat_id"
     add_foreign_key "users", "departments", column: "dept_id", primary_key: "dept_id"
end
