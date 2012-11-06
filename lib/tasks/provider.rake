namespace :provider do
  task :sample => :environment do
    Provider.all.each do |provider|
      begin
        provider.sample! true
      rescue Exception => msg
        puts msg
      end
    end
  end
end