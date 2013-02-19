class ApiController < ApplicationController

  def samples
    if request[:provider] and provider = Provider.find_by_code(request[:provider])
      response = time_series_from provider.areas.at_depth(0), params[:startDate], params[:endDate]
    else
      if area = Area.find(request[:area])
        response = time_series_from [area], params[:startDate], params[:endDate]
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

  def points

  end

  private 

  def time_series_from areas, startDate, endDate

    t_start = DateTime.strptime(startDate,'%s')
    t_end = DateTime.strptime(endDate,'%s')

    arr = areas.map do|area|
        num_records = area.samples.where(:created_at => t_start..t_end).count()
        # TODO: Put the calculated daterange mod in a cache! Redis?

        mod = num_records / 300
        samples = area.samples.where(:created_at => t_start..t_end).where("area_samples.area_seq%#{mod}=0")
        
        #Bar.find_by_sql("select * from (SELECT @rownum:=@rownum+1 rownum, t.* FROM (SELECT @rownum:=0) r, mytable t) where mod(rownum,3) = 0") 
      {
        :name => area.name, 
        :data => samples.map do |sample|
          {:x => sample.created_at.to_i, :y => sample.custs_out}
        end
      }
    end
  end

  def map_points_from collection
    collection.reject{|a| a.latitude == nil or a.longitude == nil}.to_json(:methods => :health)
  end
end
