Doesnychavepower::Application.routes.draw do
  get "/" => "power#index", :region => 'nyc'
  get "/long-island" => "power#index", :region => 'long-island'
  get "/:slug" => "power#area"
  
  # These providers have been disabled for now, it's way too much upkeep to include all of NJ.
  #get "/new-jersey" => "power#index", :region => 'new-jersey'
  # get "/pseg" => "power#provider", :provider => 'pseg'
  # get "/jcpl" => "power#provider", :provider => 'jcpl'
  # get "/orange-and-rockland" => "power#provider", :provider => 'orange-and-rockland'
end
