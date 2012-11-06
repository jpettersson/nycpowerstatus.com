namespace :geocode do

  task :areas => :environment do
    [
      ['ConEd', ", New York, NY, USA", nil], 
      ['LIPA', ", Long Island, NY", nil]
    ].each do |provider|
      unless provider[2].nil?
        areas = Provider.find_by_code(provider[0]).areas.at_depth(provider[2])
      else
        areas = Provider.find_by_code(provider[0]).areas
      end
      areas.each do |area|
        coord = Geokit::Geocoders::GoogleGeocoder.geocode "#{area.area_name}#{provider[1]}"
        if coord.success
          puts "Successfully found #{area.area_name} at: #{coord.ll}"
          area.latitude = coord.ll.split(',')[0]
          area.longitude = coord.ll.split(',')[1]
          area.save!
        else
          puts "Could not find: #{area.area_name}"
        end
        sleep 0.5
      end
    end
  end

end