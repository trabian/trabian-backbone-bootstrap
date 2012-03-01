template = require './template'

module.exports = class NavigationView extends Backbone.View

  className: 'navbar navbar-fixed-top'

  render: =>

    @$el.append template
      title: @options.title
      links: @options.links

    @
