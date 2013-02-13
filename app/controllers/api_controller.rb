class ApiController < ApplicationController

  def samples

    if request[:provider] and provider = Provider.find_by_code(request[:provider])
      response = time_series_from provider.areas.at_depth(0)
    else
      if area = Area.find(request[:area])
        response = time_series_from [area]
      else
        response = {
          :error => {
            :code => 1,
            :message => "Area not found."
          }
        }
      end
    end

    respond_to do |format|
      format.json { render :json =>  response}
    end
  end

  private 

  def time_series_from areas
    arr = areas.map do|area|
      {
        :name => area.name, 
        :data => area.samples.last(500).map do |sample|
          {:x => sample.created_at.to_i, :y => sample.custs_out}
        end
      }
    end
  end
end
