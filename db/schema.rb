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

ActiveRecord::Schema.define(:version => 20110501215436) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "favourite_categories", :force => true do |t|
    t.integer  "user_id"
    t.string   "category",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proposals", :force => true do |t|
    t.integer  "user_id",                        :null => false
    t.integer  "request_id",                     :null => false
    t.text     "description",                    :null => false
    t.integer  "amount"
    t.boolean  "is_best",     :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requests", :force => true do |t|
    t.integer  "user_id",                                     :null => false
    t.string   "status",                 :default => "draft", :null => false
    t.string   "title",                                       :null => false
    t.string   "category_id",                                 :null => false
    t.text     "description"
    t.datetime "expiration",                                  :null => false
    t.datetime "condition_confirmation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "perishable_token"
    t.integer  "login_count"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "first_name",                                   :null => false
    t.string   "last_name",                                    :null => false
    t.string   "address",                                      :null => false
    t.string   "zip",                                          :null => false
    t.string   "city",                                         :null => false
    t.boolean  "is_professional",           :default => false, :null => false
    t.string   "vat"
    t.string   "company_name"
    t.string   "activity"
    t.boolean  "confirmed",                 :default => false, :null => false
    t.datetime "last_eula_confirmation",                       :null => false
    t.datetime "last_privacy_confirmation",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
