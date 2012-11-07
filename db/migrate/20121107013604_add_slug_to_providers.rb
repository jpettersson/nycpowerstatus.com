class AddSlugToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :slug, :string
  end
end
