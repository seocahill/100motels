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

ActiveRecord::Schema.define(version: 20131125210808) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "event_users", force: true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.integer  "state",      default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_users", ["event_id"], name: "index_event_users_on_event_id", using: :btree
  add_index "event_users", ["user_id"], name: "index_event_users_on_user_id", using: :btree

  create_table "events", force: true do |t|
    t.string   "name"
    t.date     "date"
    t.decimal  "ticket_price", precision: 8, scale: 2
    t.boolean  "visible",                              default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "about"
    t.text     "about_html"
    t.string   "image"
    t.string   "location"
    t.integer  "state",                                default: 0,     null: false
    t.integer  "target",                               default: 100,   null: false
    t.integer  "user_id"
  end

  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "orders", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name",                                          null: false
    t.string   "email",                                         null: false
    t.decimal  "total",                                         null: false
    t.decimal  "ticket_price",                                  null: false
    t.string   "stripe_customer_token",                         null: false
    t.integer  "event_id",                                      null: false
    t.integer  "quantity",                        default: 1
    t.integer  "stripe_event",          limit: 8, default: 0
    t.string   "stripe_charge_id"
    t.string   "last4"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "part_refund",                     default: 0.0, null: false
  end

  add_index "orders", ["event_id"], name: "index_orders_on_event_id", using: :btree

  create_table "tickets", force: true do |t|
    t.string   "number"
    t.datetime "admitted"
    t.uuid     "order_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "auth_token"
    t.string   "password_digest"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.string   "api_key"
    t.integer  "state",                  default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "guest"
    t.string   "stripe_uid"
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree

end
