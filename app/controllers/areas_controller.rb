class AreasController < ApplicationController
  def index 
    if Provider.exists?(params[:provider_id])
      provider = Provider.find(params[:provider_id])
      areas = provider.areas
      response = areas
    else
      response = {
        :error => 2,
        :message => "Resource not found."
      }
    end

    respond_to do |format|
      format.json { render :json =>  response}
    end

  end
end