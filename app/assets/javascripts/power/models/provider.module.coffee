class Provider extends Exo.Spine.Model

  @configure 'Provider', 'region_id', 'code', 'name', 'provider_type', 'url', 'longitude', 'latitude'
  @belongsTo 'region', require 'power/models/region'
  @hasMany 'areas', require 'power/models/area'
  
  @extend Spine.Model.Ajax

module.exports = Provider