class Area < ActiveRecord::Base
  has_ancestry
  has_many :area_samples
  attr_accessible :parent, :area_name, :created_at, :latitude, :longitude, :parent_area_id, :updated_at
end
