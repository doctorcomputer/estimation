class CreateProposals < ActiveRecord::Migration
  def self.up
    create_table :proposals do |t|
      t.references :user, :null => false
      t.references :request, :null => false
      t.text :description, :null => false
      t.integer :amount
      t.boolean :is_best, :null => false, :default => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :proposals
  end
end
