Power = require 'power/models/power'

class Nav extends Exo.Spine.Controller

  className: 'nav'
    
  events: 
    'click .nyc': 'navigateToNYC'
    'click .long-island': 'navigateToLongIsland'

  prepare: ->
    Power.bind 'update', @render

  render: =>
    @html JST['power/views/nav']({
      region: Power.region.name
    })

  navigateToNYC: ->
    @navigate '/'

  navigateToLongIsland: ->
    @navigate '/long-island'

module.exports = Nav