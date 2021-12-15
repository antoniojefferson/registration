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

ActiveRecord::Schema.define(version: 2021_12_15_185507) do

  create_table "addresses", force: :cascade do |t|
    t.string "cep", null: false
    t.string "logradouro", null: false
    t.string "complement", null: false
    t.string "district", null: false
    t.string "city", null: false
    t.string "uf", null: false
    t.integer "ibge_code"
    t.integer "citizen_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["citizen_id"], name: "index_addresses_on_citizen_id"
  end

  create_table "citizens", force: :cascade do |t|
    t.string "full_name", null: false
    t.string "cpf", null: false
    t.string "cns", null: false
    t.string "email", null: false
    t.date "birth_date", null: false
    t.integer "phone", null: false
    t.string "photo"
    t.boolean "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "addresses", "citizens"
end
