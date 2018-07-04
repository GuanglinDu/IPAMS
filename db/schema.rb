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

ActiveRecord::Schema.define(version: 20180703061744) do

  create_table "addresses", force: :cascade do |t|
    t.string   "ip",               limit: 255
    t.text     "usage"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "application_form", limit: 255
    t.integer  "vlan_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mac_address",      limit: 255
    t.string   "assigner",         limit: 255
    t.boolean  "recyclable",                   default: true, null: false
  end

  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id"
  add_index "addresses", ["vlan_id"], name: "index_addresses_on_vlan_id"

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role",                               default: 0
    t.string   "name",                   limit: 255
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true

  create_table "departments", force: :cascade do |t|
    t.string   "dept_name",  limit: 255
    t.string   "location",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "histories", force: :cascade do |t|
    t.text     "usage"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "application_form", limit: 255
    t.integer  "address_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mac_address",      limit: 255
    t.string   "user_name",        limit: 255
    t.string   "dept_name",        limit: 255
    t.string   "office_phone",     limit: 8
    t.string   "cell_phone",       limit: 8
    t.string   "building",         limit: 255
    t.integer  "room"
  end

  add_index "histories", ["address_id"], name: "index_histories_on_address_id"

  create_table "lans", force: :cascade do |t|
    t.integer  "lan_number"
    t.string   "lan_name",        limit: 255
    t.text     "lan_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reserved_addresses", force: :cascade do |t|
    t.string   "ip",          limit: 255
    t.text     "description"
    t.integer  "vlan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reserved_addresses", ["vlan_id"], name: "index_reserved_addresses_on_vlan_id"

  create_table "users", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "office_phone",  limit: 8
    t.string   "cell_phone",    limit: 8
    t.string   "email",         limit: 255
    t.string   "building",      limit: 255
    t.integer  "storey"
    t.integer  "room"
    t.integer  "department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",         limit: 255
  end

  add_index "users", ["department_id"], name: "index_users_on_department_id"

  create_table "vlans", force: :cascade do |t|
    t.integer  "vlan_number"
    t.string   "vlan_name",        limit: 255
    t.string   "subnet_mask",      limit: 255
    t.string   "gateway",          limit: 255
    t.string   "static_ip_start",  limit: 255
    t.string   "static_ip_end",    limit: 255
    t.text     "vlan_description"
    t.integer  "lan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vlans", ["lan_id"], name: "index_vlans_on_lan_id"

end
