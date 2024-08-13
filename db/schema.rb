# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_08_13_174046) do
  create_table "professors", force: :cascade do |t|
    t.integer "pi_profile_id", null: false
    t.string "name"
    t.string "university"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_projects_fetch"
    t.index ["pi_profile_id"], name: "index_professors_on_pi_profile_id", unique: true
  end

  create_table "professors_projects", id: false, force: :cascade do |t|
    t.integer "professor_id", null: false
    t.integer "project_id", null: false
    t.index ["professor_id", "project_id"], name: "index_professors_projects_on_professor_id_and_project_id"
    t.index ["project_id", "professor_id"], name: "index_professors_projects_on_project_id_and_professor_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "appl_id"
    t.string "subproject_id"
    t.integer "fiscal_year"
    t.string "organization"
    t.string "project_num"
    t.string "org_country"
    t.string "project_num_split"
    t.string "contact_pi_name"
    t.text "all_text"
    t.string "full_study_section"
    t.date "project_start_date"
    t.date "project_end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appl_id"], name: "index_projects_on_appl_id"
    t.index ["project_num"], name: "index_projects_on_project_num"
  end

end
