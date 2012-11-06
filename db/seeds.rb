# Create the supported providers.
[ 
  {:code => 'ConEd', :name => "Con Edison", :provider_type => 'electricity', :url => 'http://www.conedison.com/'},
  {:code => 'LIPA', :name => "Long Island Power Authority", :provider_type => 'electricity', :url => 'http://www.lipower.org/'}
].each do |p|
    unless provider = Provider.find_by_name(p[:name])
       provider = Provider.create!(p)
    end
end

# Update the existing areas with the ConEd Provider.id
provider = Provider.find_by_code "ConEd"
Area.all.each do |area|
  provider.areas << area
end

# Sample some data.
Provider.all.each do |provider|
  begin
    provider.sample! true
  rescue Exception => msg
    puts msg
  end
end

# rake "geocode"