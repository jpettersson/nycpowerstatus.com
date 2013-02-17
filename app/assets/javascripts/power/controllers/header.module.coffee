Nav = require 'power/controllers/nav'
Title = require 'power/controllers/title'

class Header extends Exo.Spine.Controller
  tag: 'header'

  prepare: ->
    @nav = new Nav
    @append @nav.el

    @title = new Title
    @append @title.el

module.exports = Header