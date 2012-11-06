namespace :geocode do

  task :areas => :environment do
    [
      ['ConEd', ", New York, NY, USA"], 
      ['LIPA', ", Long Island, NY"]
    ].each do |provider|
      areas = Provider.find_by_code(provider[0]).areas
      areas.each do |area|
        coord = Geokit::Geocoders::YahooGeocoder.geocode "#{area.area_name}#{provider[1]}"
        if coord.success
          puts "Successfully found #{area.area_name} at: #{coord.ll}"
          area.latitude = coord.ll.split(',')[0]
          area.longitude = coord.ll.split(',')[1]
          area.save!
        else
          puts "Could not find: #{area.area_name}"
        end
      end
    end
  end

end