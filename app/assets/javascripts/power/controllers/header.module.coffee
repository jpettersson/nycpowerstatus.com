Nav = require 'power/controllers/nav'

class Header extends Exo.Spine.Controller
  tag: 'header'

  prepare: ->
    @render()

    @nav = new Nav
    @append @nav.el

  render: ->
    @html JST['power/views/header']

module.exports = Header