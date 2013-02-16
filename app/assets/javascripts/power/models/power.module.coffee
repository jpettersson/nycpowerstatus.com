Region = require 'power/models/region'
Provider = require 'power/models/provider'
Area = require 'power/models/area'

class Power extends Spine.Module
  @extend Spine.Events

  @activateRegion: (name)->
    region = Region.select((region)-> region.slug == name)[0]
    if region
      @setCurrentRegion region
    else

  @setCurrentRegion: (region)->
    @region = region
    @trigger 'update'

module.exports = Power