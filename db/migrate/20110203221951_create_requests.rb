class CreateRequests < ActiveRecord::Migration

  #active:    request is open to bids
  #expired:   request is close because of expiration date
  #draft:     not already saved
  def self.up
    create_table :requests do |t|
      t.references :user, :null => false
      t.string :status, :default=>:draft, :null=>false
      t.string :title, :null=>false
      t.string :category_id, :null=>false
      t.text :description
      t.datetime :expiration, :null=>false
      t.datetime :condition_confirmation
      t.timestamps
    end
  end

  def self.down
    drop_table :requests
  end
end
