# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160122084657) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "product_options", force: :cascade do |t|
    t.integer  "site_id"
    t.string   "name"
    t.string   "selector"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "selector_type", default: 0
  end

  add_index "product_options", ["site_id"], name: "index_product_options_on_site_id", using: :btree

  create_table "product_properties", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "product_option_id"
    t.string   "name"
    t.string   "parsed_value"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "product_properties", ["product_id"], name: "index_product_properties_on_product_id", using: :btree
  add_index "product_properties", ["product_option_id"], name: "index_product_properties_on_product_option_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.integer  "site_id"
    t.string   "path"
    t.boolean  "parsed",     default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "title"
    t.boolean  "error",      default: false
  end

  add_index "products", ["site_id"], name: "index_products_on_site_id", using: :btree

  create_table "sites", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "product_options", "sites"
  add_foreign_key "product_properties", "product_options"
  add_foreign_key "product_properties", "products"
  add_foreign_key "products", "sites"
end
