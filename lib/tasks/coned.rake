namespace :lipa do
  task :geocode => :environment do
    areas = Provider.find_by_code('LIPA').areas
    areas.each do |area|
      coord = Geokit::Geocoders::YahooGeocoder.geocode "#{area.area_name}, Long Island, NY"
      if coord.success
        puts "Successfully found #{area.area_name} at: #{coord.ll}"
        area.latitude = coord.ll.split(',')[0]
        area.longitude = coord.ll.split(',')[0]
        area.save!
      else
        puts "Could not find: #{area.area_name}"
      end
    end
  end
end