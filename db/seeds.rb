# Create the supported providers.
[ 
  {
    :code => 'ConEd', 
    :name => "Con Edison", 
    :provider_type => 'electricity', 
    :url => 'http://www.conedison.com/', 
    :longitude => '', 
    :latitude => '', 
    :slug => 'coned'
  },
  {
    :code => 'LIPA', 
    :name => "LIPA", 
    :provider_type => 'electricity', 
    :longitude => '-73.381805', 
    :latitude => '40.784909', 
    :url => 'http://www.lipower.org/', 
    :slug => 'long-island'
  },
  {
    :code => 'PSEG', 
    :name => "PSEG", 
    :provider_type => 'electricity', 
    :longitude => '-74.233246', 
    :latitude => '40.702609', 
    :url => 'http://www.pseg.com/', 
    :slug => 'new-jersey'
  },
  {
    :code => 'JCPL', 
    :name => "JCP&L", 
    :provider_type => 'electricity', 
    :longitude => '-74.451819', 
    :latitude => '40.486216', 
    :url => 'https://www.firstenergycorp.com/content/customer/jersey_central_power_light.html', 
    :slug => 'jcpl'
  },
  {
    :code => 'OrangeRockland', 
    :name => "Orange & Rockland", 
    :provider_type => 'electricity', 
    :longitude => '-74.10553', 
    :latitude => '41.224324', 
    :url => 'http://www.oru.com/', 
    :slug => 'orange-and-rockland'
  }
].each do |p|
    unless provider = Provider.find_by_name(p[:name])
       provider = Provider.create!(p)
    end
end

# Create the regions
[
  {
    :name => 'NYC',
    :longitude => '',
    :latitude => '',
    :slug => '',
    :providers => [
      Provider.find_by_code('ConEd')
    ]
  },
  {
    :name => 'Long Island',
    :longitude => '-73.381805',
    :latitude => '40.784909',
    :slug => 'long-island',
    :providers => [
      Provider.find_by_code('LIPA')
    ]
  },
  {
    :name => 'New Jersey',
    :longitude => '-73.381805',
    :latitude => '40.784909',
    :slug => 'new-jersey',
    :providers => [
      Provider.find_by_code('PSEG'), 
      Provider.find_by_code('JCPL'), 
      Provider.find_by_code('OrangeRockland')
    ]
  },
].each do |r|
  unless region = Region.find_by_name(r[:name])
    region = Region.create({
      :name => r[:name],
      :longitude => r[:longitude],
      :latitude => r[:latitude],
      :slug => r[:slug]
    })
  end

  r[:providers].each do |provider|
    region.providers << provider
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