Backbone.View::_originalConfigure = Backbone.View::_configure

_.extend Backbone.View::,

  _configure: (options) ->
    @_originalConfigure options
    @controller = options.controller
    return

  bindTo: (source, event, callback) ->

    @bindings ?= []

    source.on event, callback, @
    @bindings.push { source, event, callback }

  unbindFromAll: ->

    if @bindings?
      for binding in @bindings
        binding.source.unbind binding.event, binding.callback

  leave: ->
    @unbindFromAll()