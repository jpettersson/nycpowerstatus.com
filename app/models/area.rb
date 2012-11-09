class Area < ActiveRecord::Base
  has_ancestry :cache_depth => true
  has_many :area_samples
  belongs_to :provider
  attr_accessible :parent, :area_name, :created_at, :latitude, :longitude, :updated_at, :provider_id, :slug, :health
  
  extend FriendlyId
  friendly_id :area_name, use: :slugged

  def name
    area_name
  end

  def last_sample
    area_samples.last
  end

  def samples
    area_samples
  end

  def outage_percentage
    area_samples.last.custs_out.to_f / area_samples.last.total_custs.to_f
  end

  # If there's no % available, set the bar for a green area at 500 custs out max.
  def health
    if has_total_customers?
      outage_percentage
    else
      area_samples.last.custs_out / 500
    end
  end

  def has_total_customers?
    area_samples.last.total_custs != nil
  end

end
