Power = require 'power/models/power'
Nav = require 'power/controllers/nav'

class Header extends Exo.Spine.Controller
  tag: 'header'

  prepare: ->
    @render()

    @nav = new Nav
    @append @nav.el

  render: ->
    @html JST['power/views/header']({
      tempus: Locale['header.tempus.now']
      region: Locale["region.#{Power.getInstance().region}"]
      have_power: Locale['header.have_power']
    })

module.exports = Header