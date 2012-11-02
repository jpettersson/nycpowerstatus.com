namespace :coned do
  task :sample => :environment do
    Area.sample!
  end
end