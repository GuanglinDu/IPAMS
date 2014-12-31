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

ActiveRecord::Schema.define(version: 20141231020257) do

  create_table "addresses", force: true do |t|
    t.string   "ip"
    t.text     "usage"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "application_form"
    t.integer  "vlan_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mac_address"
  end

  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id"
  add_index "addresses", ["vlan_id"], name: "index_addresses_on_vlan_id"

  create_table "departments", force: true do |t|
    t.string   "dept_name"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "histories", force: true do |t|
    t.text     "usage"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "application_form"
    t.integer  "address_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "histories", ["address_id"], name: "index_histories_on_address_id"
  add_index "histories", ["user_id"], name: "index_histories_on_user_id"

  create_table "lans", force: true do |t|
    t.integer  "lan_number"
    t.string   "lan_name"
    t.text     "lan_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reserved_addresses", force: true do |t|
    t.string   "ip"
    t.text     "description"
    t.integer  "vlan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reserved_addresses", ["vlan_id"], name: "index_reserved_addresses_on_vlan_id"

  create_table "system_users", force: true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.integer  "office_phone"
    t.integer  "cell_phone"
    t.string   "email"
    t.string   "building"
    t.integer  "storey"
    t.integer  "room"
    t.integer  "department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["department_id"], name: "index_users_on_department_id"

  create_table "vlans", force: true do |t|
    t.integer  "vlan_number"
    t.string   "vlan_name"
    t.string   "subnet_mask"
    t.string   "gateway"
    t.string   "static_ip_start"
    t.string   "static_ip_end"
    t.text     "vlan_description"
    t.integer  "lan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vlans", ["lan_id"], name: "index_vlans_on_lan_id"

end
