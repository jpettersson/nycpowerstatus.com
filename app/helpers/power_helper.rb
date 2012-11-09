module PowerHelper
  def pretty_percentage offline, total=0
    if total > 0
      num = offline.to_f / total.to_f
      arr = (num * 100).to_s.split(".")
      if arr.length == 2
        return "#{arr[0]}.#{arr[1][0..1]}%"
      end
    end
    offline
  end

  def map_points_from collection
    # or a.disable_location == true
    # :include => :last_sample, 
    collection.reject{|a| a.latitude == nil or a.longitude == nil}.to_json(:methods => :health)
  end

  def time_series_from areas
    arr = areas.map do|area|
      {
        :name => area.name, 
        :data => area.samples.limit(10000).map do |sample|
          {:x => sample.created_at.to_i, :y => sample.custs_out}
        end
      }
    end
    arr.to_json
  end
end
