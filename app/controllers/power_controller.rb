class PowerController < ApplicationController
  def index
    @areas = Area.at_depth(0)
    @total_outage = Area.root_outage_percentage

    if @total_outage < 0.02
      res = 'low'
    elsif @total_outage < 0.08
      res = 'medium'
    else
      res = 'high'
    end

    @time_series_json = create_time_series @areas
    @map_points_json = create_map_points @areas

    @total_outage_percent = (@total_outage * 100).to_s.split(".")[0]
    @total_customers = view_context.number_to_human(Area.root_total_customers)
    @response = t("index.responses.#{res}", {:num => @total_outage_percent, :total_customers => @total_customers, :link => view_context.link_to(t('index.coned_working'), t('index.coned_twitter'))})
  end

  def area
    @area = Area.find(params[:slug])
    @total_outage = @area.outage_percentage
    num = (@total_outage * 100).to_s.split(".")
    @total_outage_percent = "#{num[0]}.#{num[1][0..1]}"

    if @area.children.length > 0
      @map_points_json = create_map_points @area.children
      @time_series_json = create_time_series [@area]
    else
      @map_points_json = create_map_points [@area]
      @time_series_json = create_time_series [@area]
    end
  end

  def create_map_points areas
    areas.reject{|a| a.latitude == nil or a.longitude == nil }.to_json(:include => :last_sample)
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