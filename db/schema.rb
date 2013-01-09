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

ActiveRecord::Schema.define(:version => 20130108210135) do

  create_table "accidents", :force => true do |t|
    t.integer  "numac"
    t.string   "codeinsee"
    t.string   "ville"
    t.integer  "lumiere"
    t.integer  "intersection"
    t.integer  "atmospherique"
    t.integer  "collision"
    t.integer  "route"
    t.integer  "tues"
    t.integer  "hospitalises"
    t.integer  "leger"
    t.integer  "indemnes"
    t.decimal  "gravite",       :precision => 5, :scale => 2
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.boolean  "vehicule_1"
    t.boolean  "vehicule_2"
    t.boolean  "vehicule_3"
    t.boolean  "vehicule_4"
    t.boolean  "vehicule_5"
    t.boolean  "vehicule_6"
  end

  add_index "accidents", ["numac"], :name => "index_accidents_on_numac", :unique => true
  add_index "accidents", ["vehicule_1"], :name => "index_details_on_vehicule_1"
  add_index "accidents", ["vehicule_2"], :name => "index_details_on_vehicule_2"
  add_index "accidents", ["vehicule_3"], :name => "index_details_on_vehicule_3"
  add_index "accidents", ["vehicule_4"], :name => "index_details_on_vehicule_4"
  add_index "accidents", ["vehicule_5"], :name => "index_details_on_vehicule_5"
  add_index "accidents", ["vehicule_6"], :name => "index_details_on_vehicule_6"

  create_table "details", :force => true do |t|
    t.integer  "numac"
    t.integer  "vehicule"
    t.integer  "misecirc"
    t.integer  "tues"
    t.integer  "hospitalises"
    t.integer  "legers"
    t.integer  "indemnes"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "details", ["numac"], :name => "index_details_on_numac"

  create_table "radars", :force => true do |t|
    t.integer  "categorie"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "radars", ["categorie"], :name => "index_radars_on_type"

end
