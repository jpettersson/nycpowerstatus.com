class AddCoordinatesToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :latitude, :string
    add_column :providers, :longitude, :string
  end
end
