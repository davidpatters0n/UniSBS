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

ActiveRecord::Schema.define(:version => 20120321163036) do

  create_table "admin_levels", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "booking_logentries", :force => true do |t|
    t.integer  "booking_id"
    t.string   "site"
    t.string   "company"
    t.string   "reference_number"
    t.datetime "provisional_appointment"
    t.datetime "confirmed_appointment"
    t.integer  "pallets_expected"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bookings", :force => true do |t|
    t.integer  "company_id"
    t.string   "reference_number"
    t.datetime "provisional_appointment"
    t.datetime "confirmed_appointment"
    t.integer  "pallets_expected"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "diary_time_id"
    t.boolean  "live"
    t.string   "comment"
    t.boolean  "double_decker"
    t.boolean  "moved"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tms"
  end

  create_table "company_logentries", :force => true do |t|
    t.string  "name"
    t.string  "tms"
    t.integer "company_id"
  end

  create_table "diary_days", :force => true do |t|
    t.date     "day"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "diary_times", :force => true do |t|
    t.integer  "diary_day_id"
    t.integer  "minute_of_day"
    t.integer  "capacity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "granularities", :force => true do |t|
    t.integer  "minutes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logclasses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logentries", :force => true do |t|
    t.integer  "logclass_id"
    t.integer  "loggable_id"
    t.string   "loggable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_logentries", :force => true do |t|
    t.integer  "site_id"
    t.string   "company"
    t.string   "booking"
    t.string   "name"
    t.integer  "past_days_to_keep"
    t.integer  "days_in_advance"
    t.integer  "provisional_bookings_expire_after"
    t.integer  "granularity_minutes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.integer  "past_days_to_keep"
    t.integer  "days_in_advance"
    t.integer  "provisional_bookings_expire_after"
    t.integer  "granularity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "soas", :force => true do |t|
    t.string   "next_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "template_capacities", :force => true do |t|
    t.integer  "site_id"
    t.integer  "minutes"
    t.integer  "weekend_capacity"
    t.integer  "weekday_capacity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                       :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.string   "nickname"
    t.integer  "admin_level_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
