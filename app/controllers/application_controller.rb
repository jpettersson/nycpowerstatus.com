class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :get_footer_data

  def get_footer_data
    @updated_at = AreaSample.last.updated_at.in_time_zone("Eastern Time (US & Canada)").strftime("%m/%d/%Y %H:%M EDT")
  end
end
