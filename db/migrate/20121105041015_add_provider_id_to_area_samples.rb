class AddProviderIdToAreaSamples < ActiveRecord::Migration
  def change
    add_column :area_samples, :provider_id, :integer
  end
end
