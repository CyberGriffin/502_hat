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

ActiveRecord::Schema[7.0].define(version: 2025_02_15_061333) do
  create_table "admins", force: :cascade do |t|
    t.string "email", null: false
    t.string "full_name"
    t.string "uid"
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "categories", primary_key: "name", id: :string, force: :cascade do |t|
    t.string "parent_category"
    t.string "icon"
    t.string "color_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "departments", id: :string, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventories", force: :cascade do |t|
    t.string "item_sku"
    t.date "year_of_purchase"
    t.string "location"
    t.string "condition_of_item"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", primary_key: "sku", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "category_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parent_categories", primary_key: "parent_category", id: :string, force: :cascade do |t|
    t.string "icon"
    t.string "color_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_inventories", force: :cascade do |t|
    t.string "owner_email"
    t.string "user_email"
    t.integer "inventory_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", primary_key: "email", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "role"
    t.string "department_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
