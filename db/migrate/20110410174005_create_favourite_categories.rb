class CreateFavouriteCategories < ActiveRecord::Migration
  def self.up
    create_table :favourite_categories do |t|
      t.references :user
      t.string :category
      t.timestamps
    end
  end

  def self.down
    drop_table :favourite_categories
  end
end
