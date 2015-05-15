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

ActiveRecord::Schema.define(version: 20150515073238) do

  create_table "organizations", force: :cascade do |t|
    t.string   "name",        limit: 255, null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name",            null: false
    t.integer  "organization_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["organization_id"], name: "index_projects_on_organization_id"

  create_table "user_organizations", force: :cascade do |t|
    t.integer  "user_id",                         null: false
    t.integer  "organization_id",                 null: false
    t.boolean  "admin",           default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_organizations", ["organization_id", "user_id"], name: "index_user_organizations_on_organization_id_and_user_id"
  add_index "user_organizations", ["user_id", "organization_id"], name: "index_user_organizations_on_user_id_and_organization_id", unique: true

  create_table "user_projects", force: :cascade do |t|
    t.integer  "user_id",                    null: false
    t.integer  "project_id",                 null: false
    t.boolean  "admin",      default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_projects", ["project_id", "user_id"], name: "index_user_projects_on_project_id_and_user_id"
  add_index "user_projects", ["user_id", "project_id"], name: "index_user_projects_on_user_id_and_project_id", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   default: "", null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
