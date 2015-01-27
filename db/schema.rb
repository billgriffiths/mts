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

ActiveRecord::Schema.define(version: 20141119220839) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answer_records", force: true do |t|
    t.string   "problem"
    t.string   "decoded_answer"
    t.datetime "start_time"
    t.integer  "test_result_id"
    t.integer  "course_id"
    t.integer  "test_template_id"
  end

  create_table "courses", force: true do |t|
    t.string  "course_name"
    t.string  "class_number"
    t.integer "instructor_id"
  end

  create_table "courses_students", id: false, force: true do |t|
    t.integer "course_id"
    t.integer "student_id"
  end

  add_index "courses_students", ["course_id", "student_id"], name: "index_courses_students_on_course_id_and_student_id", using: :btree
  add_index "courses_students", ["student_id"], name: "index_courses_students_on_student_id", using: :btree

  create_table "courses_test_templates", id: false, force: true do |t|
    t.integer "course_id"
    t.integer "test_template_id"
  end

  add_index "courses_test_templates", ["course_id", "test_template_id"], name: "index_courses_test_templates_on_course_id_and_test_template_id", using: :btree
  add_index "courses_test_templates", ["test_template_id"], name: "index_courses_test_templates_on_test_template_id", using: :btree

  create_table "instructors", force: true do |t|
    t.string "first_name"
    t.string "last_name"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "students", force: true do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "student_number"
  end

  create_table "test_results", force: true do |t|
    t.string   "answers"
    t.text     "test_items"
    t.float    "score"
    t.string   "status"
    t.datetime "start_time"
    t.integer  "student_id"
    t.integer  "course_id"
    t.integer  "test_template_id"
  end

  create_table "test_templates", force: true do |t|
    t.string  "name"
    t.text    "template"
    t.string  "description"
    t.integer "course_id"
    t.integer "instructor_id"
  end

  create_table "users", force: true do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "user_name"
    t.string "password"
    t.string "role"
    t.string "password_digest"
  end

end
