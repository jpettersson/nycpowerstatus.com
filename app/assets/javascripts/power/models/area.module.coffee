class Area extends Exo.Spine.Model

  @configure 'Provider', 'area_name', 'slug', 'longitude', 'latitude', 'provider_id'
  @extend Spine.Model.Ajax

module.exports = Area