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

ActiveRecord::Schema.define(:version => 20121030231437) do

  create_table "carts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "artist"
    t.string   "venue"
    t.date     "date"
    t.time     "doors"
    t.datetime "created_at",                                                               :null => false
    t.datetime "updated_at",                                                               :null => false
    t.decimal  "ticket_price",                :precision => 8, :scale => 2
    t.integer  "promoter_id"
    t.integer  "venue_capacity"
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
    t.integer  "state",          :limit => 8,                               :default => 0
    t.integer  "profile_id"
  end

  add_index "events", ["location_id"], :name => "index_events_on_location_id"
  add_index "events", ["profile_id"], :name => "index_events_on_profile_id"

  create_table "line_items", :force => true do |t|
    t.integer  "event_id"
    t.integer  "cart_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "quantity",    :default => 1
    t.integer  "order_id"
    t.integer  "promoter_id"
    t.boolean  "purchased"
  end

  add_index "line_items", ["cart_id"], :name => "index_line_items_on_cart_id"
  add_index "line_items", ["event_id"], :name => "index_line_items_on_event_id"

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
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.decimal  "total"
    t.string   "stripe_customer_token"
    t.string   "plan"
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "quantity",                           :default => 1
    t.integer  "stripe_event",          :limit => 8, :default => 0
    t.string   "stripe_charge_id"
    t.string   "last4"
  end

  add_index "orders", ["event_id"], :name => "index_orders_on_event_id"
  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "state",               :default => 0
    t.boolean  "visible",             :default => false
    t.string   "encrypted_api_key"
    t.string   "promoter_name"
    t.string   "image"
    t.string   "available"
    t.string   "fee"
    t.string   "promoter_media"
    t.string   "promoter_media_html"
    t.text     "quick_profile"
    t.text     "about"
    t.text     "equipment"
    t.text     "venues"
    t.text     "travel"
    t.text     "accomodation"
    t.text     "support"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "location_id"
  end

  add_index "profiles", ["location_id"], :name => "index_profiles_on_location_id"
  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "requests", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "state",      :limit => 8, :default => 0
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "requests", ["event_id"], :name => "index_requests_on_event_id"
  add_index "requests", ["profile_id"], :name => "index_requests_on_profile_id"
  add_index "requests", ["user_id"], :name => "index_requests_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false
    t.string   "customer_id"
    t.string   "name"
    t.string   "avatar"
    t.integer  "last4"
    t.string   "media"
    t.string   "media_html"
    t.integer  "location_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["location_id"], :name => "index_users_on_location_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
