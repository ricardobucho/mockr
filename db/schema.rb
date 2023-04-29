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

ActiveRecord::Schema[7.0].define(version: 2023_04_01_143032) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_clients_on_deleted_at"
  end

  create_table "logs", force: :cascade do |t|
    t.bigint "request_id", null: false
    t.jsonb "data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_logs_on_request_id"
  end

  create_table "requests", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.string "name", null: false
    t.text "description"
    t.string "method", null: false
    t.string "path", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["client_id", "path"], name: "index_requests_on_client_id_and_path", unique: true
    t.index ["client_id"], name: "index_requests_on_client_id"
    t.index ["deleted_at"], name: "index_requests_on_deleted_at"
  end

  create_table "responses", force: :cascade do |t|
    t.bigint "request_id", null: false
    t.string "name", null: false
    t.text "description"
    t.jsonb "conditions", default: {}, null: false
    t.integer "status", default: 200, null: false
    t.jsonb "headers", default: {}, null: false
    t.string "path", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "format", default: "json", null: false
    t.index ["deleted_at"], name: "index_responses_on_deleted_at"
    t.index ["request_id", "name"], name: "index_responses_on_request_id_and_name", unique: true
    t.index ["request_id"], name: "index_responses_on_request_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "token", null: false
    t.string "role", default: "user", null: false
    t.string "provider", null: false
    t.string "provider_uid", null: false
    t.string "provider_username", null: false
    t.string "provider_email", null: false
    t.string "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["provider_email", "provider"], name: "index_users_on_provider_email_and_provider", unique: true
    t.index ["provider_uid", "provider"], name: "index_users_on_provider_uid_and_provider", unique: true
    t.index ["token"], name: "index_users_on_token"
  end

  add_foreign_key "logs", "requests"
  add_foreign_key "requests", "clients"
  add_foreign_key "responses", "requests"
end
