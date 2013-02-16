Server = require 'power/config/server'
Locale = require 'power/config/locale_en'
Power = require 'power/models/power'
Header = require 'power/controllers/header'

Spine.Model.host = Server.baseURL
Power.init()

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
    Power.activateRegion name

$ ->
  new PowerApp
    el: ($ 'body')