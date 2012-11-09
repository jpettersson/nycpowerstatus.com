class Region < ActiveRecord::Base
  has_and_belongs_to_many :providers
  #has_many :areas, :through => :providers
  attr_accessible :latitude, :longitude, :name, :slug
end
