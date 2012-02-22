template = require './template'

module.exports = class NavigationView extends Backbone.View

  className: 'navbar navbar-fixed-top'

  render: =>

    locals =
      title: @options.title

    @$el.append template locals

    @
