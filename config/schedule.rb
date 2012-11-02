set :output, "#{path}/log/cron_log.log"

every 1.hour do
  rake "coned:sample"
end
