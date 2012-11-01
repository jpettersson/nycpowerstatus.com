class AreaSample < ActiveRecord::Base
  belongs_to :area
  attr_accessible :area_id, :created_at, :custs_out, :etr, :etrmillis, :total_custs, :updated_at
end
