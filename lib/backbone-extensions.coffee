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

      @$el.append @make 'p', { class: 'flash' }, window.flash
      window.flash = null

  bindValidations: (validationBindings) ->

    return if @validationsBound

    @validationsBound = true

    unless validationPresenter = @options.validationPresenter

      validationPresenter = new Backbone.Model

      Backbone.Validation.bind this,
        valid: (view, attr) ->
          validationPresenter.unset attr

        invalid: (view, attr, error) ->
          validationPresenter.set attr, error

    return unless validationBindings

    if _.isArray validationBindings

      validationBindings = _(validationBindings).reduce (bindings, field) ->
        bindings[field] = "[name=#{field}]"
        bindings
      , {}

    for field, selector of validationBindings

      do (field, selector) =>

        @bindToAndTrigger validationPresenter, "change:#{field}", ->

          _.defer =>

            $group = @$(selector).closest '.control-group,.error-container'

            if message = validationPresenter.get field

              $group.addClass 'error'

              $textContainer = $group.find('.controls,.error-text')
              $messageContainer = $textContainer.find '.help-block.error-message'

              unless $messageContainer.length
                $messageContainer = $('<p class="help-block error-message" />').appendTo $textContainer

              $messageContainer.text message

            else
              $group.removeClass('error').find('.help-block.error-message').remove()


    validationPresenter

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

          @set "#{name}_formatted", formatted, forceUpdate: false

        @on "change:#{name}", format

        format()

  toUpdateJSON: -> @toJSON()

  createAndBind: (models) ->

    for name, model of models

      do (name, model) =>

        @[name] = model

        @set name, model.attributes

        model.on 'change', =>
          @set name, model.attributes

  isDeepValid: ->

    if @relatedValidationModels?

      # No need to keep track of whether any of the models are invalid --
      # that's already being handled via the "[related_model]_invalid". This
      # allows the top-level model to be valid even if the related models are
      # invalid if those invalid models are not required.
      _.each @relatedValidationModels, (model) ->
        model.isDeepValid()

    @isValid true

  validateRelated: (related...) ->

    @relatedValidationModels ?= []

    for field in related

      do (field) =>

        @bindAndTrigger "change:#{field}", =>

          if model = @get field

            @relatedValidationModels.push model

            model.on 'validated', =>
              @set "#{field}_valid", model.isValid()

Backbone.Validation.configure
  forceUpdate: true

_.extend Backbone.Model::, Backbone.Validation.mixin
