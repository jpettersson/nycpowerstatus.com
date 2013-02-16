class Nav extends Exo.Spine.Controller

  prepare: ->
    @render()

  render: ->
    @html JST['power/views/nav']()

module.exports = Nav