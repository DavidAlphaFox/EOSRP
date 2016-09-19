create_table :users, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.varchar :uid
  t.varchar :provider, null: false, default: "eve_online"
  t.varchar :encrypted_password, null: false, default: ""

  ## Recoverable
  t.varchar   :reset_password_token, null: true, default: ""
  t.datetime :reset_password_sent_at, null: true

  ## Rememberable
  t.datetime :remember_created_at, null: true

  ## Trackable
  t.int  :sign_in_count, default: 0, null: false
  t.datetime :current_sign_in_at, null: true
  t.datetime :last_sign_in_at, null: true
  t.varchar   :current_sign_in_ip, default: ""
  t.varchar   :last_sign_in_ip, default:""

  # Confirmable
  t.varchar   :confirmation_token, null: true
  t.datetime :confirmed_at, null: true
  t.datetime :confirmation_sent_at, null: true
  t.varchar   :unconfirmed_email,null: true # Only if using reconfirmable

  ## User Info
  t.varchar :name, null: true
  t.varchar :nickname, null: true
  t.varchar :image, null: true
  t.varchar :email, null: true

  ## Tokens
  t.text :tokens

  t.datetime :created_at
  t.datetime :updated_at
end

create_table :guarantee_types, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.varchar :name
  t.varchar :description, null: true
  t.datetime :created_at
  t.datetime :updated_at
end

create_table :guarantees, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.int :ship_id
  t.int :guarantee_type_id
  t.decimal :price, comment: "保証額", default: 0
  t.varchar :description, null: true
  t.datetime :created_at
  t.datetime :updated_at
end

create_table :temp_market_orders, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.bigint :order_id
  t.int :type_id
  t.boolean :buy, null: true
  t.datetime :issued, null: true
  t.decimal :price, null: true, precision: 20, scale: 4
  t.int :volume_entered, null: true
  t.bigint :station_id, null: true
  t.int :volume, null: true
  t.varchar :range, null: true
  t.int :min_volume, null: true
  t.int :duration, null: true
  t.datetime :created_at, null: true
  t.datetime :updated_at, null: true


  t.index [:type_id, :buy, :station_id], name: "index_type_id_and_buy_and_station_id"
end

create_table :market_orders, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.bigint :order_id
  t.int :type_id
  t.boolean :buy, null: true
  t.datetime :issued, null: true
  t.decimal :price, null: true, precision: 20, scale: 4
  t.int :volume_entered, null: true
  t.bigint :station_id, null: true
  t.int :volume, null: true
  t.varchar :range, null: true
  t.int :min_volume, null: true
  t.int :duration, null: true
  t.datetime :created_at, null: true
  t.datetime :updated_at, null: true


  t.index [:type_id, :buy, :station_id], name: "index_type_id_and_buy_and_station_id"
end

## Master ##
create_table :ships, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.varchar :ship_type
  t.varchar :ship_name
end

create_table :sta_stations, collate: "utf8_bin" do |t|
  t.int :id, primary_key: true, extra: :auto_increment
  t.bigint :station_id
  t.int :region_id
  t.int :solar_system_id
  t.varchar :station_name

  t.index ["station_id"], name: "index_station_id"
  t.index ["solar_system_id"], name: "index_solar_system_id"
end
