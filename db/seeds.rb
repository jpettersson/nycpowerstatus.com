# Create the supported providers.
[ 
  {:code => 'ConEd', :name => "Con Edison", :provider_type => 'electricity', :url => 'http://www.conedison.com/', :longitude => '', :latitude => '', :slug => ''},
  {:code => 'LIPA', :name => "Long Island Power Authority", :provider_type => 'electricity', :longitude => '-73.381805', :latitude => '40.784909', :url => 'http://www.lipower.org/', :slug => 'long-island'},
  {:code => 'PSEG', :name => "Public Service Enterprise Group", :provider_type => 'electricity', :longitude => '-74.233246', :latitude => '40.702609', :url => 'http://www.pseg.com/', :slug => 'new-jersey'}
].each do |p|
    unless provider = Provider.find_by_name(p[:name])
       provider = Provider.create!(p)
    end
end

# Sample some data.
# Provider.all.each do |provider|
#   begin
#     provider.sample! true
#   rescue Exception => msg
#     puts msg
#   end
# end

# rake "geocode"