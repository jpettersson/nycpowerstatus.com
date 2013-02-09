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

  end

end