class Provider < ActiveRecord::Base
  has_many :areas
  has_many :area_samples, :through => :areas
  attr_accessible :code, :name, :provider_type, :url, :longitude, :latitude, :slug

  OUTAGE_THRESHOLD = {
    :low => 0.2,
    :medium => 0.4,
    :high => 0.6
  }

  def root_area
    area = Area.new({
      :area_name => name,
      :slug => slug,
      :longitude => longitude,
      :latitude => latitude
    })

    area.area_samples << AreaSample.new({
      :total_custs => total_customers,
      :custs_out => customers_affected
    })

    area
  end

  def data_updated_at
    area_samples.last.updated_at.in_time_zone("Eastern Time (US & Canada)").strftime("%m/%d/%Y %H:%M EDT")
  end

  def total_customers
    areas.at_depth(root_depth).map{|a| a.area_samples.last.total_custs}.inject(:+)
  end

  def customers_affected
    areas.at_depth(root_depth).map{|a| a.area_samples.last.custs_out}.inject(:+)
  end

  def outage_percentage
    a = areas.at_depth(root_depth)
    total = a.map{|a| a.area_samples.last.total_custs}
    out = a.map{|a| a.area_samples.last.custs_out}

    out.inject(:+).to_f / total.inject(:+).to_f
  end

  def sample! force=false
    # Fetch data.
    sandy_provider = Object.const_get('Sandy').const_get('Provider').const_get(code)
    report = sandy_provider.const_get('Report').new

    # Create areas
    if report
      puts "Sample: #{code}"
      puts Time.new.inspect
      sample_areas report.areas
      puts "Done Sampling"
    end

  end


  private 

  def root_depth
      0
  end

  def sample_areas sandy_areas, lvl=0, parent=nil
    if sandy_areas 
      sandy_areas.each do |sandy_area|

        # First, we need to create Areas we don't already have
        if parent 
          area = parent.children.find_by_area_name sandy_area.name
        else
          area = Area.at_depth(0).find_by_area_name sandy_area.name
        end

        unless area
          data = {
            :area_name => sanitize_name(sandy_area.name),
            :latitude => sandy_area.latitude,
            :longitude => sandy_area.longitude,
            :provider_id => id
          }
          if parent
            area = parent.children.create! data 
          else
            area = Area.create!(data)
          end
        end

        # Next, let's do the actual sampling
        last_sample = area.samples.last
        if last_sample.nil? or not last_sample.values_identical? sandy_area 
          puts "#{"  " * lvl } << #{area.area_name}"
          AreaSample.create!({
            :area_id => area.id, 
            :total_custs => sandy_area.total_customers, 
            :custs_out => sandy_area.customers_affected, 
            :etr => sandy_area.estimated_recovery_time,
          })
        else
          puts "#{"  " * lvl } #{area.area_name}"
        end

        # Finally, does this area have any child areas we need to sample?
        if sandy_area.children
          sample_areas sandy_area.children, lvl+1, area
        end

      end
    end
  end

  def sanitize_name str
    str.split(' ').map {|w| w.downcase.capitalize }.join(' ')
  end

end
