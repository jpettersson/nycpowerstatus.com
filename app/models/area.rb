class Area < ActiveRecord::Base
  has_ancestry :cache_depth => true
  has_many :area_samples
  attr_accessible :parent, :area_name, :created_at, :latitude, :longitude, :parent_area_id, :updated_at
  
  extend FriendlyId
  friendly_id :area_name, use: :slugged

  def self.sample! force=false
    require 'coned'
    c = Coned.new
    c.fetch

    do_sample = ->(area, raw){
      AreaSample.create!({:area_id => area.id, :total_custs => raw.total_custs, :custs_out => raw.custs_out, :etr => raw.etr, :etrmillis => raw.etrmillis})
    }

    # Only create a new sample if coned has updated the values.
    maybe_sample = ->(area, raw){
      unless force
        last = area.samples.last
        unless last.nil?
          unless last.total_custs == raw.total_custs and last.custs_out == raw.custs_out and last.etr == raw.etr
            puts "sample: #{raw.area_name.to_s} #{raw.custs_out.to_s} / #{raw.total_custs.to_s}"
            do_sample.call(area, raw)
          end
        end
      else
        do_sample.call(area, raw)
      end
    }

    puts 'start sampling'
    puts Time.new.inspect
    c.data.areas.each {|b| 
      area = Area.find_by_area_name(b.area_name)
      maybe_sample.call(area, b)

      b.areas.each {|n|
        sub_area = Area.find_by_area_name(n.area_name)
        maybe_sample.call(sub_area, n)
      }
    } 
    puts 'end sampling'
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

  def last_sample
    area_samples.last
  end

  def samples
    area_samples
  end

  def outage_percentage
    area_samples.last.custs_out.to_f / area_samples.last.total_custs.to_f
  end

end
