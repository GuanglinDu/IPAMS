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

ActiveRecord::Schema.define(version: 20141028070538) do

  create_table "lans", force: true do |t|
    t.integer  "lan_number"
    t.string   "lan_name"
    t.text     "lan_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
