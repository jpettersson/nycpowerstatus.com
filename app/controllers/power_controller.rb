class PowerController < ApplicationController
  def index
    @provider = Provider.find_by_code(params[:provider])
    @updated_at = @provider.data_updated_at
  
    # LIPA's data comes in three levels, but the first level is pretty useless
    # with only 3 regions, whereof one is empty. Skipping ahead to the second
    # level instead:

    extra_areas = []

    if @provider.code == "LIPA"
      @areas = @provider.areas.at_depth(1).reject{|a| a.is_hidden }
    elsif @provider.code == "PSEG"
      @areas = @provider.areas.at_depth(0).reject{|a| a.is_hidden }
    elsif @provider.code == "ConEd"
      @areas = @provider.areas.at_depth(0).reject{|a| a.is_hidden }
      extra_areas.push Provider.find_by_code('LIPA').root_area
      extra_areas.push Provider.find_by_code('PSEG').root_area
    end

    unless @provider.total_customers == 0
      @total_outage = @provider.outage_percentage
      @pretty_outage_percent = pretty_percentage @total_outage
      @total_customers = view_context.number_to_human(@provider.total_customers)
    else
      @total_outage = ""
      @pretty_outage_percent = view_context.number_to_human(@provider.customers_affected)
    end
    
    @time_series_json = create_time_series @areas
    @map_points_json = create_map_points(@areas + extra_areas)
  end

  def area
    @area = Area.find(params[:slug])
    @provider = @area.provider
    @updated_at = @provider.data_updated_at
   
    @areas = @area.children.reject{|a| a.is_hidden }

    if @area.has_total_customers?
      @total_outage = @area.outage_percentage
      @pretty_outage_percent = pretty_percentage @total_outage
      @total_customers = view_context.number_to_human(@provider.total_customers)
    else
      @total_outage = @area.last_sample.custs_out
      @pretty_outage_percent = @total_outage
      @total_customers = ""
    end

    if @area.children.length > 0
      @map_points_json = create_map_points @area.children.reject{|a| a.is_hidden }
      @time_series_json = create_time_series [@area]
    else
      @map_points_json = create_map_points [@area]
      @time_series_json = create_time_series [@area]
    end
  end

  def pretty_percentage num
    num = (@total_outage * 100).to_s.split(".")
    @pretty_outage_percent = "#{num[0]}.#{num[1][0..1]}%"
  end

  def create_map_points areas
    areas.reject{|a| a.latitude == nil or a.longitude == nil or a.disable_location == true}.to_json(:include => :last_sample, :methods => :health)
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