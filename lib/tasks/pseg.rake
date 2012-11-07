namespace :pseg do
  task :test => :environment do
    report = Sandy::Provider::PSEG::Report.new
  end
end