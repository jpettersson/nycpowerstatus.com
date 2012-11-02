class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :get_footer_data

  def get_footer_data
    @updated_at = AreaSample.last.updated_at
  end
end
