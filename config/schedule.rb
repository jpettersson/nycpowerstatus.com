set :output, "#{path}/log/cron_log.log"

every 15.minutes do
  rake "coned:sample"
end
