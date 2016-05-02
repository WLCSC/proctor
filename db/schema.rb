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

ActiveRecord::Schema.define(:version => 20160425184802) do

  create_table "enrollments", :force => true do |t|
    t.integer  "exam_id"
    t.integer  "student_id"
    t.string   "comment"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "alternate"
    t.boolean  "repeated"
    t.boolean  "discount"
  end

  create_table "exams", :force => true do |t|
    t.string   "name"
    t.date     "date"
    t.integer  "session"
    t.decimal  "cost",                   :precision => 6, :scale => 2
    t.text     "description"
    t.boolean  "real"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.decimal  "discount",               :precision => 6, :scale => 2
    t.integer  "limit"
    t.boolean  "self_enrollable"
    t.integer  "supervisor_id"
    t.text     "supervisor_information"
  end

  create_table "payments", :force => true do |t|
    t.decimal  "change",     :precision => 6, :scale => 2
    t.string   "comment"
    t.integer  "user_id"
    t.integer  "student_id"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "kind"
  end

  create_table "students", :force => true do |t|
    t.string   "name"
    t.decimal  "balance",    :precision => 6, :scale => 2
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.boolean  "frl"
    t.string   "email"
  end

  create_table "supervisors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.boolean  "administrator"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "email_address"
    t.string   "password_hash"
    t.string   "password_salt"
  end

end
