Nav = require 'power/controllers/nav'

class PowerApp extends Exo.Spine.Controller

  prepare: ->
    console.log "Power!"
    @render()

    @nav = new Nav
      el: ($ 'header')

  render: ->
    @html JST['power/views/index']

$ ->
  new PowerApp
    el: ($ 'body')