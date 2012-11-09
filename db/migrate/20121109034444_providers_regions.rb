class ProvidersRegions < ActiveRecord::Migration
  def change
    create_table :providers_regions, :id => false do |t|
      t.integer :provider_id
      t.integer :region_id
    end
  end
end
