class CreateAreaSamples < ActiveRecord::Migration
  def change
    create_table :area_samples do |t|
      t.integer :area_id
      t.integer :total_custs
      t.integer :custs_out
      t.string :etr
      t.integer :etrmillis
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
