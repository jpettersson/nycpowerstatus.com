class Provider extends Exo.Spine.Model

  @configure 'Provider', 'region_id', 'code', 'name', 'provider_type', 'url', 'longitude', 'latitude', 'total_customers', 'offline_customers'

  @belongsTo 'region', require('power/models/region')
  @hasMany 'areas', require('power/models/area')
  
  @extend Spine.Model.Ajax

  onlinePercentage: ->
    p = (1-(@offline_customers / @total_customers) * 100)
    p = p.toString().match(/^\d+(?:\.\d{0,2})?/)
    "#{p}%"

module.exports = Provider