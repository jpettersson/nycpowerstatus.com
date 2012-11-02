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

    @total_outage_percent = (@total_outage * 100).to_s.split(".")[0]
    @total_customers = view_context.number_to_human(Area.root_total_customers)
    @response = t("index.responses.#{res}", {:num => @total_outage_percent, :total_customers => @total_customers, :link => view_context.link_to(t('index.coned_working'), t('index.coned_twitter'))})
  end

  def area
    @area = Area.find(params[:slug])
    @total_outage = @area.outage_percentage
    @total_outage_percent = (@total_outage * 100).to_s.split(".")[0]
  end
end