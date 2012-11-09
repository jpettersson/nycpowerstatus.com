class AddIsHiddenToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :is_hidden, :boolean
  end
end
