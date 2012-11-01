class AddCacheDepthToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :ancestry_depth, :integer, :default => 0
  end
end
