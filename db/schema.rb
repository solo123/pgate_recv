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

ActiveRecord::Schema.define(version: 20160914040311) do

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.string   "organization_id"
    t.string   "tmk"
    t.integer  "d0_min_fee"
    t.integer  "d0_min_percent"
    t.integer  "status"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "jg_signins", force: :cascade do |t|
    t.string   "result_text"
    t.string   "terminal_info"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "jgp_b001s", force: :cascade do |t|
    t.integer  "parent_id",       default: 0
    t.string   "send_time"
    t.string   "send_seq_id"
    t.string   "trans_type"
    t.string   "organization_id"
    t.integer  "pay_pass"
    t.string   "img_url"
    t.integer  "trans_amt"
    t.integer  "fee"
    t.string   "card_no"
    t.string   "name"
    t.string   "id_num"
    t.string   "body"
    t.string   "notify_url"
    t.string   "resp_code"
    t.string   "resp_desc"
    t.string   "mac"
    t.integer  "status",          default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "kf_gateways", force: :cascade do |t|
    t.integer  "parent_id",       default: 0
    t.string   "send_time"
    t.string   "send_seq_id"
    t.string   "trans_type"
    t.string   "organization_id"
    t.string   "pay_pass"
    t.string   "img_url"
    t.string   "trans_amt"
    t.string   "fee"
    t.string   "card_no"
    t.string   "name"
    t.string   "id_num"
    t.string   "body"
    t.string   "notify_url"
    t.string   "callback_url"
    t.string   "resp_code"
    t.string   "resp_desc"
    t.string   "mac"
    t.integer  "status",          default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "parent_id",      default: 0
    t.string   "service"
    t.string   "version"
    t.string   "agency_id"
    t.string   "trade_no"
    t.integer  "fee"
    t.string   "return_url"
    t.string   "notify_url"
    t.integer  "expire_minutes"
    t.string   "shop_id"
    t.string   "counter_id"
    t.string   "operator_id"
    t.string   "desc"
    t.string   "coupon_tag"
    t.string   "nonce_str"
    t.string   "sign"
    t.integer  "status",         default: 0
    t.datetime "op_time"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "recv_posts", force: :cascade do |t|
    t.string   "method"
    t.string   "remote_host"
    t.string   "header"
    t.string   "params"
    t.text     "detail"
    t.integer  "status",      default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

end
