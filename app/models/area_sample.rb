class AreaSample < ActiveRecord::Base
  belongs_to :area
  belongs_to :provider
  attr_accessible :area_id, :created_at, :custs_out, :etr, :etrmillis, :total_custs, :updated_at, :provider_id

  def values_identical? sandy_area
    total_custs == sandy_area.total_customers and custs_out == sandy_area.customers_affected
  end
end
