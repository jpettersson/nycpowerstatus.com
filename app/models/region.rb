class Region < ActiveRecord::Base
  has_many :region_providers
  has_many :providers, :through => :region_providers
  has_many :areas, :through => :providers
  attr_accessible :latitude, :longitude, :name, :slug
end
