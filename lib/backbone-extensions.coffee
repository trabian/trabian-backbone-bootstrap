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

  bindToAndTrigger: (source, event, callback) ->
    @bindTo source, event, callback
    callback()

  unbindFromAll: ->

    if @bindings?
      for binding in @bindings
        binding.source.unbind binding.event, binding.callback

  leave: ->
    @remove()
    @unbindFromAll()
    @undelegateEvents()
    @leaveChildren?()
    Backbone.ModelBinding.unbind @

  flash: ($el) ->

    if window.flash

      @$el.append "<p class='flash'>#{window.flash}</p>"
      window.flash = null

_.extend Backbone.Model::,

  bindAndTrigger: (event, callback) ->

    @on event, callback

    callback()

  format: (formatters) ->

    for name, formatter of formatters

      do (name, formatter) =>

        format = =>

          formatted = if val = @get name
            formatter val, @
          else
            ''

          @set "#{name}_formatted", formatted

        @on "change:#{name}", format

        format()

  createAndBind: (models) ->

    for name, model of models

      do (name, model) =>

        @[name] = model

        @set name, model.attributes

        model.on 'change', =>
          @set name, model.attributes

  validateRelated: (related...) ->

    for field in related

      do (field) =>

        @bindAndTrigger "change:#{field}", =>

          if model = @get field

            model.on 'validated', =>
              @set "#{field}_valid", model.isValid()

Backbone.Validation.configure
  forceUpdate: true

_.extend Backbone.Model::, Backbone.Validation.mixin
