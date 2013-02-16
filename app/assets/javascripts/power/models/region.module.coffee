class Region extends Exo.Spine.Model

  @configure 'Region', 'name', 'slug', 'longitude', 'latitude'
  @hasMany 'providers', require('power/models/provider')
  @extend Spine.Model.Ajax

module.exports = Region