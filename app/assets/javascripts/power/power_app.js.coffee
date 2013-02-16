Locale = require 'power/config/locale_en'
Power = require 'power/models/power'
Header = require 'power/controllers/header'

class PowerApp extends Exo.Spine.Controller

  constructor: ->
    @routes
      '/': =>
        @activateRegion 'nyc'
      '/long-island': =>
        @activateRegion 'long-island'

    window.Locale = Locale

    super

  prepare: ->
    @header = new Header
    @prepend @header.el

    unless window.location.hash
      @activateRegion 'nyc'
    else
      Spine.Route.setup()

  activateRegion: (name)->
    console.log 'activateRegion: ', name
    power = Power.getInstance()
    power.region = name
    power.save()

$ ->
  new PowerApp
    el: ($ 'body')