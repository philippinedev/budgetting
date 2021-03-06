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

ActiveRecord::Schema.define(version: 2021_09_24_023626) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_types", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_account_types_on_name", unique: true
  end

  create_table "accounts", force: :cascade do |t|
    t.bigint "account_type_id"
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "deactivated_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_type_id"], name: "index_accounts_on_account_type_id"
  end

  create_table "entities", force: :cascade do |t|
    t.bigint "parent_id"
    t.boolean "is_parent", default: false
    t.string "code", null: false
    t.string "name", null: false
    t.string "description"
    t.datetime "deactivated_at"
    t.decimal "transaction_fee", precision: 10, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_entities_on_code", unique: true
    t.index ["name"], name: "index_entities_on_name", unique: true
    t.index ["parent_id"], name: "index_entities_on_parent_id"
  end

  create_table "summaries", force: :cascade do |t|
    t.bigint "transaction_id", null: false
    t.string "transaction_name", null: false
    t.text "data", default: "{}"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["transaction_id"], name: "index_summaries_on_transaction_id"
  end

  create_table "transaction_types", force: :cascade do |t|
    t.bigint "source_category_id"
    t.bigint "target_category_id"
    t.bigint "expense_category_id"
    t.string "name", null: false
    t.string "description"
    t.integer "mode", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["expense_category_id"], name: "index_transaction_types_on_expense_category_id"
    t.index ["name"], name: "index_transaction_types_on_name", unique: true
    t.index ["source_category_id"], name: "index_transaction_types_on_source_category_id"
    t.index ["target_category_id"], name: "index_transaction_types_on_target_category_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "transaction_type_id", null: false
    t.bigint "source_account_id"
    t.bigint "target_account_id", null: false
    t.bigint "expense_account_id"
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "PHP", null: false
    t.integer "fee_cents", default: 0, null: false
    t.string "fee_currency", default: "PHP", null: false
    t.date "cutoff_date"
    t.date "due_date"
    t.datetime "actualized_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_id"], name: "index_transactions_on_created_by_id"
    t.index ["expense_account_id"], name: "index_transactions_on_expense_account_id"
    t.index ["source_account_id"], name: "index_transactions_on_source_account_id"
    t.index ["target_account_id"], name: "index_transactions_on_target_account_id"
    t.index ["transaction_type_id"], name: "index_transactions_on_transaction_type_id"
    t.index ["updated_by_id"], name: "index_transactions_on_updated_by_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts", "account_types"
  add_foreign_key "entities", "entities", column: "parent_id"
  add_foreign_key "summaries", "transactions"
  add_foreign_key "transaction_types", "entities", column: "expense_category_id"
  add_foreign_key "transaction_types", "entities", column: "source_category_id"
  add_foreign_key "transaction_types", "entities", column: "target_category_id"
  add_foreign_key "transactions", "entities", column: "expense_account_id"
  add_foreign_key "transactions", "entities", column: "source_account_id"
  add_foreign_key "transactions", "entities", column: "target_account_id"
  add_foreign_key "transactions", "transaction_types"
  add_foreign_key "transactions", "users", column: "created_by_id"
  add_foreign_key "transactions", "users", column: "updated_by_id"
end
