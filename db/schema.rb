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

ActiveRecord::Schema.define(:version => 20130522091323) do

  create_table "field_descriptors", :force => true do |t|
    t.string "name"
    t.string "field_type"
  end

  create_table "field_descriptors_node_descriptors", :force => true do |t|
    t.integer "node_descriptor_id"
    t.integer "field_descriptor_id"
  end

  create_table "fields", :force => true do |t|
    t.integer "node_id"
    t.integer "field_descriptor_id"
    t.text "data"
  end

  create_table "node_descriptors", :force => true do |t|
    t.string "name"
  end

  create_table "node_relations", :force => true do |t|
    t.integer "parent_node_id"
    t.integer "child_node_id"
  end

  create_table "nodes", :force => true do |t|
    t.integer "node_descriptor_id"
  end

  create_table "relation_descriptors", :force => true do |t|
    t.string "name"
    t.integer "node_descriptor_id"
    t.integer "child_node_descriptor_id"
  end

end