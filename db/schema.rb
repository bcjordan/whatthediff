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

ActiveRecord::Schema.define(version: 20140909052341) do

  create_table "diffs", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "snapshot_a_id"
    t.integer  "snapshot_b_id"
    t.string   "image_url"
    t.boolean  "different"
    t.integer  "page_list_id"
    t.integer  "page_list_capture_id"
  end

  create_table "page_list_captures", force: true do |t|
    t.integer  "page_list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_lists", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "urls"
    t.string   "secret_key"
  end

  create_table "page_lists_pages", force: true do |t|
    t.integer  "page_id"
    t.integer  "page_list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: true do |t|
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "snapshots", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "email"
    t.string   "image_url"
    t.integer  "page_list_id"
    t.integer  "page_list_capture_id"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
