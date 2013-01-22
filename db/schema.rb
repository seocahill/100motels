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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130121153601) do

  create_table "event_users", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.integer  "state",      :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "event_users", ["event_id"], :name => "index_event_users_on_event_id"
  add_index "event_users", ["user_id"], :name => "index_event_users_on_user_id"

  create_table "events", :force => true do |t|
    t.string   "artist"
    t.string   "venue"
    t.date     "date"
    t.time     "doors"
    t.decimal  "ticket_price",              :precision => 8, :scale => 2
    t.integer  "state",        :limit => 8,                               :default => 0
    t.boolean  "visible",                                                 :default => false
    t.datetime "created_at",                                                                 :null => false
    t.datetime "updated_at",                                                                 :null => false
    t.integer  "capacity"
    t.integer  "target"
    t.text     "about"
    t.text     "about_html"
    t.string   "video"
    t.string   "video_html"
    t.string   "music"
    t.string   "music_html"
    t.string   "image"
    t.string   "image_html"
    t.integer  "location_id"
  end

  add_index "events", ["location_id"], :name => "index_events_on_location_id"

  create_table "guest_profiles", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "locations", :force => true do |t|
    t.string   "address"
    t.string   "city"
    t.string   "country"
    t.string   "zip"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "locations", ["latitude", "longitude"], :name => "index_locations_on_latitude_and_longitude"

  create_table "member_profiles", :force => true do |t|
    t.string   "name"
    t.string   "avatar"
    t.string   "email"
    t.string   "password_digest"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "member_profiles", ["auth_token"], :name => "index_member_profiles_on_auth_token"
  add_index "member_profiles", ["email"], :name => "index_member_profiles_on_email"

  create_table "oauth_access_grants", :force => true do |t|
    t.integer  "resource_owner_id", :null => false
    t.integer  "application_id",    :null => false
    t.string   "token",             :null => false
    t.integer  "expires_in",        :null => false
    t.string   "redirect_uri",      :null => false
    t.datetime "created_at",        :null => false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], :name => "index_oauth_access_grants_on_token", :unique => true

  create_table "oauth_access_tokens", :force => true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id",    :null => false
    t.string   "token",             :null => false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        :null => false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], :name => "index_oauth_access_tokens_on_refresh_token", :unique => true
  add_index "oauth_access_tokens", ["resource_owner_id"], :name => "index_oauth_access_tokens_on_resource_owner_id"
  add_index "oauth_access_tokens", ["token"], :name => "index_oauth_access_tokens_on_token", :unique => true

  create_table "oauth_applications", :force => true do |t|
    t.string   "name",         :null => false
    t.string   "uid",          :null => false
    t.string   "secret",       :null => false
    t.string   "redirect_uri", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "oauth_applications", ["uid"], :name => "index_oauth_applications_on_uid", :unique => true

  create_table "orders", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.decimal  "total"
    t.string   "stripe_customer_token"
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "quantity",                           :default => 1
    t.integer  "stripe_event",          :limit => 8, :default => 0
    t.string   "stripe_charge_id"
    t.string   "last4"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  add_index "orders", ["event_id"], :name => "index_orders_on_event_id"
  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "tickets", :force => true do |t|
    t.string   "number"
    t.integer  "order_id"
    t.integer  "event_id"
    t.datetime "admitted"
    t.integer  "quantity_counter"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "tickets", ["event_id"], :name => "index_tickets_on_event_id"
  add_index "tickets", ["order_id"], :name => "index_tickets_on_order_id"

  create_table "users", :force => true do |t|
    t.integer  "profile_id"
    t.string   "profile_type"
    t.string   "auth_token"
    t.string   "encrypted_api_key"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "encrypted_customer_id"
    t.string   "card_type"
    t.string   "exp_year"
    t.string   "exp_month"
    t.string   "last4"
    t.string   "cvc_check"
    t.string   "country"
  end

  add_index "users", ["auth_token"], :name => "index_users_on_auth_token"
  add_index "users", ["profile_id"], :name => "index_users_on_profile_id"
  add_index "users", ["profile_type"], :name => "index_users_on_profile_type"

end
