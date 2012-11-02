class PowerController < ApplicationController
  def index
    @areas = Area.at_depth(0)
    @total_outage = (Area.root_outage_percentage * 100)

    if @total_outage < 0.2
      res = 'low'
    elsif @total_outage < 0.4
       res = 'medium'
    else
       res = 'high'
    end

    @total_outage_percent = @total_outage.to_s.split(".")[0]
    @total_customers = view_context.number_to_human(Area.root_total_customers)
    @response = t("index.responses.#{res}", {:num => @total_outage_percent, :total_customers => @total_customers})
  end

  def area
    @area = Area.find(params[:slug])
    @total_outage = (@area.outage_percentage * 100)
    @total_outage_percent = @total_outage.to_s.split(".")[0]
  end
end