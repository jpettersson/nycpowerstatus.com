class Provider < ActiveRecord::Base
  has_many :areas
  has_many :area_samples
  attr_accessible :code, :name, :provider_type, :url

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

  def sample_areas areas, lvl=0, parent=nil
    if areas 
      areas.each do |sandy_area|

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
            :provider => self
          }
          if parent
            area = parent.children.create! data 
          else
            area = Area.create! data
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
            :provider => self
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
