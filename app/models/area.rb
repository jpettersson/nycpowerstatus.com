class Area < ActiveRecord::Base
  has_ancestry :cache_depth => true
  has_many :area_samples
  attr_accessible :parent, :area_name, :created_at, :latitude, :longitude, :parent_area_id, :updated_at
  
  extend FriendlyId
  friendly_id :area_name, use: :slugged

  def self.sample!
    require 'coned'
    c = Coned.new
    c.fetch

    c.data.areas.each {|b| 
      puts "Burough: #{b.area_name}: #{b.custs_out}/#{b.total_custs} out/total"
      area = Area.find_by_area_name(b.area_name)
      AreaSample.create!({:area_id => area.id, :total_custs => b.total_custs, :custs_out => b.custs_out, :etr => b.etr, :etrmillis => b.etrmillis})
      b.areas.each {|n|
        puts "  Neighborhood: #{n.area_name} #{n.custs_out}/#{n.total_custs} out/total"
        sub_area = Area.find_by_area_name(n.area_name)
        AreaSample.create!({:area_id => sub_area.id, :total_custs => n.total_custs, :custs_out => n.custs_out, :etr => n.etr, :etrmillis => n.etrmillis})
      }
    } 
  end

  def self.root_total_customers
    Area.at_depth(0).map{|a| a.area_samples.last.total_custs}.inject(:+)
  end

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
