class CreateProposals < ActiveRecord::Migration
  def self.up
    create_table :proposals do |t|
      t.references :user, :null => false
      t.references :request, :null => false
      t.text :description
      t.integer :amount
      
      t.timestamps
    end
  end

  def self.down
    drop_table :proposals
  end
end
