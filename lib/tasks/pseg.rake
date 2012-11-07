namespace :pseg do
  task :test => :environment do
    report = Sandy::Provider::PSEG::Report.new
    puts "Report areas: #{report.areas.length}"
  end
end