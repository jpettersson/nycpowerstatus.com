namespace :geocode do

  task :fetch => :environment do
    [
      #['ConEd', ", New York, NY, USA", nil], 
      #['LIPA', ", Long Island, NY", nil],
      #['PSEG', ", New Jersey, USA", nil],
      ['JCPL', ", New Jersey, USA", nil],
      ['OrangeRockland', ", New Jersey, USA", nil]
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

  task :dump => :environment do
    ['ConEd', 'LIPA', 'PSEG', 'OrangeRockland', 'JCPL'].each do |provider_name|
      if provider = Provider.find_by_code(provider_name)
        coords = {}
        provider.areas.each do |area|
          coords[area.name.downcase] = {
            :latitude => area.latitude,
            :longitude => area.longitude
          }
        end

        File.open(File.join(Rails.root, 'db', 'fixtures', provider_name, "gps_data.yml"), 'w') {|f| f.write(coords.to_yaml) }
      end
    end
  end

  task :save => :environment do

    # Using the slug as identification means we have to rely on the specific 
    # ordering (and nesting) withing the provider's area list. 
    coords = Area.all.map{ |a|
      {
        :area_slug => a.slug,
        :longitude => a.longitude,
        :latitude => a.latitude,
        :disable_location => a.disable_location,
        :is_hidden => a.is_hidden
      } 
    }
    File.open(File.join(Rails.root, 'db', 'fixtures', 'area_coordinates.yml'), 'w') {|f| f.write(coords.to_yaml) }
  end

  task :load => :environment do
    coords = YAML::load(File.open(File.join(Rails.root, 'db', 'fixtures', 'area_coordinates.yml')))
    coords.each do |coord|
      area = Area.find_by_slug coord.fetch(:area_slug)
      if area
        puts "Updating coords for: #{area.area_name}"
        area.longitude = coord.fetch(:longitude)
        area.latitude = coord.fetch(:latitude)
        area.disable_location = coord.fetch(:disable_location)
        area.is_hidden = coord.fetch(:is_hidden)
        area.save
      else
        puts "Area #{coord.fetch(:area_slug).to_s} was not found."
      end
    end
  end

end