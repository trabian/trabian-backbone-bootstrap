module.exports = class Controller extends Backbone.Model

  show: (name, view, options) =>
    @trigger 'show', name, view, options

  open: (name, view, options) =>
    @show name, view, options
