class Power extends Exo.Spine.Model

  # Holds the main application state: selected date range, area, etc.
  @defaults
    region: 'nyc'
    area: ''

  @configure 'Power', 'region', 'area'

  @getInstance: ->
    unless Power.instance
      Power.instance = Power.create()
      
    return Power.instance

module.exports = Power