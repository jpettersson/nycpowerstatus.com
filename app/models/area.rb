class Area < ActiveRecord::Base
  has_ancestry
  has_many :area_samples
  attr_accessible :parent, :area_name, :created_at, :latitude, :longitude, :parent_area_id, :updated_at

  def outage_percentage
  	area_samples.last.custs_out / area_samples.last.total_custs
  end

  def max_historic_outage

  end

  def min_historic_outage

  end
end
