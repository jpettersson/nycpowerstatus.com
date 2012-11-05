class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :code
      t.string :name
      t.string :provider_type
      t.string :url

      t.timestamps
    end
  end
end
