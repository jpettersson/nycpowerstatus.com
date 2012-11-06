class AddFlagsToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :disable_location, :boolean
    add_column :areas, :is_hidden, :boolean
  end
end
