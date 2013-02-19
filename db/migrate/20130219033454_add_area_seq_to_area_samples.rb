class AddAreaSeqToAreaSamples < ActiveRecord::Migration
  def change
    add_column :area_samples, :area_seq, :integer
  end
end
