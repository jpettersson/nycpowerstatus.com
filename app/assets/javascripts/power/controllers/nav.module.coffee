Power = require 'power/models/power'

class Nav extends Exo.Spine.Controller

  events: 
    'click .nyc': 'navigateToNYC'
    'click .long-island': 'navigateToLongIsland'

  prepare: ->
    Power.bind 'update', @render
    
  render: =>
    @html JST['power/views/nav'](Power.getInstance())

  navigateToNYC: ->
    @navigate '/'

  navigateToLongIsland: ->
    @navigate '/long-island'

module.exports = Nav