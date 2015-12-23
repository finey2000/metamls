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

ActiveRecord::Schema.define(version: 20151223081203) do

  create_table "bookmarks", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.integer  "property_id",  limit: 4
    t.boolean  "alert",                      default: false
    t.integer  "rating",       limit: 1,     default: 0
    t.text     "note",         limit: 65535
    t.datetime "note_updated"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "bookmarks", ["property_id"], name: "index_bookmarks_on_property_id", using: :btree
  add_index "bookmarks", ["user_id"], name: "index_bookmarks_on_user_id", using: :btree

  create_table "properties", force: :cascade do |t|
    t.integer  "source_id",       limit: 4
    t.string   "asset_url",       limit: 255,                               null: false
    t.string   "source_asset_id", limit: 255,                               null: false
    t.string   "address",         limit: 255,                               null: false
    t.string   "city",            limit: 255,                               null: false
    t.string   "state",           limit: 2,                                 null: false
    t.integer  "zip",             limit: 4,                                 null: false
    t.string   "img_thumbnail",   limit: 255
    t.string   "img_large",       limit: 255
    t.datetime "listed_date"
    t.datetime "start_date",                                                null: false
    t.datetime "end_date"
    t.decimal  "current_price",               precision: 10,                null: false
    t.boolean  "auction",                                                   null: false
    t.boolean  "internet_sale",                                             null: false
    t.boolean  "residential",                                default: true
    t.string   "size",            limit: 20
    t.integer  "year_built",      limit: 8
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
  end

  add_index "properties", ["source_id"], name: "index_properties_on_source_id", using: :btree

  create_table "sources", force: :cascade do |t|
    t.string   "slug",             limit: 30,                   null: false
    t.string   "url",              limit: 255,                  null: false
    t.string   "source_type",      limit: 10,                   null: false
    t.string   "listing_type",     limit: 15,                   null: false
    t.boolean  "active",                         default: true
    t.integer  "update_frequency", limit: 4,     default: 24
    t.text     "note",             limit: 65535
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "scraper_class",    limit: 40,                   null: false
  end

  add_index "sources", ["slug"], name: "index_sources_on_slug", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",        limit: 255, null: false
    t.string   "firstname",       limit: 255
    t.string   "surname",         limit: 255
    t.string   "email",           limit: 255, null: false
    t.string   "password_digest", limit: 255, null: false
    t.string   "token",           limit: 255
    t.datetime "timeout"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
