set :output, "#{path}/log/cron_log.log"

every 5.minutes do
  rake "provider:sample"
end
