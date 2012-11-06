set :output, "#{path}/log/cron_log.log"

every 15.minutes do
  rake "provider:sample"
end
