class Area < ActiveRecord::Base
  has_ancestry :cache_depth => true
  has_many :area_samples
  attr_accessible :parent, :area_name, :created_at, :latitude, :longitude, :parent_area_id, :updated_at

  def self.root_outage_percentage
    areas = Area.at_depth(0)
    total = areas.map{|a| a.area_samples.last.total_custs}
    out = areas.map{|a| a.area_samples.last.custs_out}

    out.inject(:+).to_f / total.inject(:+).to_f
  end

  def outage_percentage
    area_samples.last.custs_out.to_f / area_samples.last.total_custs.to_f
  end

  def max_historic_outage

  end

  def min_historic_outage

  end
end
