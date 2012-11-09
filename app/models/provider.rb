class Provider < ActiveRecord::Base
  has_and_belongs_to_many :regions
  has_many :areas
  has_many :area_samples, :through => :areas
  attr_accessible :code, :name, :provider_type, :url, :longitude, :latitude, :slug

  OUTAGE_THRESHOLD = {
    :low => 0.2,
    :medium => 0.4,
    :high => 0.6
  }

  # LIPA's data comes in three levels, but the first level is pretty useless
  # with only 3 regions, whereof one is empty. Skipping ahead to the second
  # level instead:
  # def areas
  #   if code == "LIPA"
  #     areas.at_depth(1).reject{|a| a.is_hidden }
  #   else
  #     areas.at_depth(0).reject{|a| a.is_hidden }
  #   end
  # end

  def data_updated_at
    area_samples.last.updated_at.in_time_zone("Eastern Time (US & Canada)").strftime("%m/%d/%Y %H:%M EDT")
  end

  def has_total_customers?
    total_customers > 0
  end

  def total_customers
    areas.at_depth(root_depth).map{|a| a.area_samples.last.total_custs || 0}.inject(:+) || 0
  end

  def offline_customers
    areas.at_depth(root_depth).map{|a| a.area_samples.last.custs_out || 0}.inject(:+)
  end

  def outage_percentage
    a = areas.at_depth(root_depth)
    total = a.map{|a| a.area_samples.last.total_custs || 0}
    out = a.map{|a| a.area_samples.last.custs_out || 0}

    out.inject(:+).to_f / total.inject(:+).to_f
  end

  def health
    if has_total_customers?
      outage_percentage
    else
      if area_samples.last
       area_samples.last.custs_out / 500
      else
        0
      end
    end
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
