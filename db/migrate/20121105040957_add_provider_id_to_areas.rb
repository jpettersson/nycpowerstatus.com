class AddProviderIdToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :provider_id, :integer
  end
end
