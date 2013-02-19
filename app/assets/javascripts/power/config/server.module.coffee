module.exports = 
  'baseURL': 'http://172.16.30.14:3000'
  'areaSampleURL': (opts) -> "#{@baseURL}/api/area/#{opts.area}/samples?startDate=#{opts.startDate}&endDate=#{opts.endDate}"