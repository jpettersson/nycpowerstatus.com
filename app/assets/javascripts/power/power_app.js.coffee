Header = require 'power/controllers/header'

class PowerApp extends Exo.Spine.Controller

  prepare: ->
    console.log "Power!"

    @header = new Header
    @prepend @header.el

$ ->
  new PowerApp
    el: ($ 'body')