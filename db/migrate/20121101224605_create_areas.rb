class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :area_name
      t.integer :parent_area_id
      t.string :latitude
      t.string :longitude
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
