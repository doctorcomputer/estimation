class CreateRequests < ActiveRecord::Migration

  def self.up
    create_table :requests do |t|
      t.references :user, :null => false
      #active:    request is open to bids
      #expired:   request is close because of expiration date
      #draft:     not already saved
      t.string :status, :default=>:draft, :null=>false
      t.string :title
      t.text :description
      t.datetime :expiration
      t.datetime :condition_confirmation

      t.timestamps
    end
  end

  def self.down
    drop_table :requests
  end
end
