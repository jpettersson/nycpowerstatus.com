class PowerController < ApplicationController
  def index
    @region = Region.find_by_slug(params[:region])
    @providers = @region.providers.reject{|p| p.is_hidden }
  end

  def provider 
    @provider = Provider.find_by_slug(params[:provider])
  end

  def area
    if params[:is_provider]
      @area = Provider.find_by_slug(params[:slug])
      @region = @area.regions.first
      @sub_areas = @area.areas.at_depth(0)
    else
      @area = Area.find(params[:slug])
      @region = @area.provider.regions.first
      if @area.children.length > 0
        @sub_areas = @area.children.reject{|a| a.is_hidden }
      else
        @sub_areas = []
      end
    end

    # if @area.has_total_customers?
    #   @total_outage = @area.outage_percentage
    #   @pretty_outage_percent = pretty_percentage @total_outage
    #   @total_customers = view_context.number_to_human(@provider.total_customers)
    # else
    #   @total_outage = @area.last_sample.custs_out
    #   @pretty_outage_percent = @total_outage
    #   @total_customers = ""
    # end

    # if @area.children.length > 0
    #   @map_points_json = create_map_points @area.children.reject{|a| a.is_hidden }
    #   @time_series_json = create_time_series [@area]
    # else
    #   @map_points_json = create_map_points [@area]
    #   @time_series_json = create_time_series [@area]
    # end
  end

end