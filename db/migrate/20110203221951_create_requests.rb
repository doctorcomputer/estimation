class CreateRequests < ActiveRecord::Migration
  def self.up
    create_table :requests do |t|
      t.integer :status
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
