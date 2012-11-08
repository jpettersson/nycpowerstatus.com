class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :name
      t.string :slug
      t.string :longitude
      t.string :latitude

      t.timestamps
    end
  end
end
