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

ActiveRecord::Schema.define(version: 2020_07_26_105525) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "login", null: false
    t.string "password", null: false
    t.bigint "master_server_id", null: false
    t.integer "premium_points"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email"
    t.index ["master_server_id"], name: "index_accounts_on_master_server_id"
  end

  create_table "accounts_worlds", id: false, force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "world_id", null: false
  end

  create_table "master_servers", force: :cascade do |t|
    t.string "link", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "players", force: :cascade do |t|
    t.integer "external_id"
    t.string "name"
    t.integer "points"
    t.integer "rank"
    t.bigint "world_id", null: false
    t.bigint "account_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "tribe_id"
    t.index ["account_id"], name: "index_players_on_account_id"
    t.index ["tribe_id"], name: "index_players_on_tribe_id"
    t.index ["world_id", "external_id"], name: "index_players_on_world_id_and_external_id", unique: true
    t.index ["world_id"], name: "index_players_on_world_id"
  end

  create_table "task_logs", force: :cascade do |t|
    t.integer "worker_id"
    t.bigint "account_id", null: false
    t.string "task_class"
    t.string "args"
    t.string "status"
    t.string "error"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_task_logs_on_account_id"
  end

  create_table "tribes", force: :cascade do |t|
    t.integer "external_id"
    t.bigint "world_id", null: false
    t.string "name"
    t.string "tag"
    t.integer "points"
    t.integer "rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["world_id", "external_id"], name: "index_tribes_on_world_id_and_external_id", unique: true
    t.index ["world_id"], name: "index_tribes_on_world_id"
  end

  create_table "villages", force: :cascade do |t|
    t.integer "external_id", null: false
    t.integer "x_coord"
    t.integer "y_coord"
    t.bigint "owner_id", null: false
    t.bigint "world_id", null: false
    t.integer "points"
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id"], name: "index_villages_on_owner_id"
    t.index ["world_id", "external_id"], name: "index_villages_on_world_id_and_external_id", unique: true
    t.index ["world_id"], name: "index_villages_on_world_id"
  end

  create_table "worlds", force: :cascade do |t|
    t.string "name", null: false
    t.string "link", null: false
    t.text "world_config"
    t.text "unit_config"
    t.text "building_config"
    t.bigint "master_server_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["master_server_id"], name: "index_worlds_on_master_server_id"
  end

  add_foreign_key "accounts", "master_servers"
  add_foreign_key "players", "accounts"
  add_foreign_key "players", "tribes"
  add_foreign_key "players", "worlds"
  add_foreign_key "task_logs", "accounts"
  add_foreign_key "tribes", "worlds"
  add_foreign_key "villages", "players", column: "owner_id"
  add_foreign_key "villages", "worlds"
  add_foreign_key "worlds", "master_servers"
end
