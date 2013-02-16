class RegionsController < ApplicationController
  respond_to :json
  inherit_resources
  actions :index
end