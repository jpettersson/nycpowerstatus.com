class PowerController < ApplicationController
  def index
    @provider = Provider.find_by_code(params[:provider])

    # LIPA's data comes in three levels, but the first level is pretty useless
    # with only 3 regions, whereof one is empty. Skipping ahead to the second
    # level instead:

    extra_areas = []

    if @provider.code == "LIPA"
      @areas = @provider.areas.at_depth(1).reject{|a| a.is_hidden }
    else
      @areas = @provider.areas.at_depth(0).reject{|a| a.is_hidden }
      extra_areas.push Provider.find_by_code('LIPA').root_area
    end

    @total_outage = @provider.outage_percentage
    num = (@total_outage * 100).to_s.split(".")
    @pretty_outage_percent = "#{num[0]}.#{num[1][0..1]}%"
    
    @time_series_json = create_time_series @areas
    @map_points_json = create_map_points(@areas + extra_areas)

    @total_customers = view_context.number_to_human(@provider.total_customers)
  end

  def area
    @area = Area.find(params[:slug])
    @provider = @area.provider
    
    @areas = @area.children.reject{|a| a.is_hidden }
    @total_outage = @area.outage_percentage
    num = (@total_outage * 100).to_s.split(".")
    if num.length == 2
      @pretty_outage_percent = "#{num[0]}.#{num[1][0..1]}%"
    else
      @pretty_outage_percent = "an unknown number"
    end

    if @area.children.length > 0
      @map_points_json = create_map_points @area.children.reject{|a| a.is_hidden }
      @time_series_json = create_time_series [@area]
    else
      @map_points_json = create_map_points [@area]
      @time_series_json = create_time_series [@area]
    end
  end

  def create_map_points areas
    areas.reject{|a| a.latitude == nil or a.longitude == nil or a.disable_location == true}.to_json(:include => :last_sample)
  end

  def create_time_series areas
    arr = areas.map do|area|
      {
        :name => area.area_name, 
        :data => area.samples.limit(10000).map do |sample|
          {:x => sample.created_at.to_i, :y => sample.custs_out}
        end
      }
    end
    arr.to_json
  end

end