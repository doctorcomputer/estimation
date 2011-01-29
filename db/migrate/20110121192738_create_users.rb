class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login
      t.string :email
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.string :perishable_token
      t.integer :login_count
      t.datetime :last_login_at
      t.datetime :current_login_at

      t.string :first_name, :null=>false
      t.string :last_name,  :null=>false
      t.string :address,    :null=>false
      t.string :zip,        :null=>false
      t.string :city,       :null=>false
      t.boolean :is_professional, :null=>false, :default=>false
      t.string :vat, :null=>true
      t.string :company_name, :null=>true
      t.string :activity, :null=>true

      t.boolean :is_verified, :null=>false, :default=>false

      t.datetime :last_eula_confirmation, :null=>false
      t.datetime :last_privacy_confirmation, :null=>false

      

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
