Power = require 'power/models/power'

class Title extends Exo.Spine.Controller

  prepare: ->
    Power.bind 'update', @render

  render: =>

    @html JST['power/views/header']({
      tempus: Locale['header.tempus.now']
      region: Power.region
      have_power: Locale['header.have_power']
      percentage_online: Power.region.provider().onlinePercentage()
      provider: Power.region.provider().name
      num_customers: Power.region.provider().total_customers
    })

module.exports = Title