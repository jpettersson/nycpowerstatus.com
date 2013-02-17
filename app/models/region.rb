class Region < ActiveRecord::Base
  has_and_belongs_to_many :providers
  #has_many :areas, :through => :providers
  attr_accessible :latitude, :longitude, :name, :slug

  def as_json(options = { })
      super((options || { }).merge({
          :include => {
            :providers => {
              :methods => [:total_customers, :offline_customers]
            }
          }
      }))
  end
end
