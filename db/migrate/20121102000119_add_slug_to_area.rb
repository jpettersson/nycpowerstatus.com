class AddSlugToArea < ActiveRecord::Migration
  def change
    add_column :areas, :slug, :string
  end
end
