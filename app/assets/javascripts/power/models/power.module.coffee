Region = require 'power/models/region'
Provider = require 'power/models/provider'
Area = require 'power/models/area'

class Power extends Spine.Module
  @extend Spine.Events

  @init: ->
    Region.bind 'refresh', @onRegions

  @activateRegion: (name)->
    region = Region.select((region)-> region.slug == name)[0]
    if region
      @setCurrentRegion region
    else
      @nextRegionSlug = name
      Region.fetch()

  @setCurrentRegion: (region)->
    @region = region
    @trigger 'update'

  @onRegions: =>
    if @nextRegionSlug
      @activateRegion @nextRegionSlug

module.exports = Power