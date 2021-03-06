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

ActiveRecord::Schema.define(:version => 20121109071224) do

  create_table "area_samples", :force => true do |t|
    t.integer  "area_id"
    t.integer  "total_custs"
    t.integer  "custs_out"
    t.string   "etr"
    t.integer  "etrmillis"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "areas", :force => true do |t|
    t.string   "area_name"
    t.string   "latitude"
    t.string   "longitude"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "ancestry"
    t.integer  "ancestry_depth",   :default => 0
    t.string   "slug"
    t.integer  "provider_id"
    t.boolean  "disable_location"
    t.boolean  "is_hidden"
  end

  add_index "areas", ["ancestry"], :name => "index_areas_on_ancestry"

  create_table "providers", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "provider_type"
    t.string   "url"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "latitude"
    t.string   "longitude"
    t.string   "slug"
    t.boolean  "is_hidden"
  end

  create_table "providers_regions", :id => false, :force => true do |t|
    t.integer "provider_id"
    t.integer "region_id"
  end

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "longitude"
    t.string   "latitude"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
