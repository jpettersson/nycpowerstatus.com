module PowerHelper
  def pretty_online_percentage offline_customers, total=0
    if total > 0
      num = 1-(offline_customers.to_f / total.to_f)
      arr = (num * 100).to_s.split(".")
      if arr.length == 2
        return "#{arr[0]}.#{arr[1][0..1]}%"
      end
    else
      "no data"
    end
  end
end
