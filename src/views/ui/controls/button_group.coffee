module.exports = class ButtonGroup extends Backbone.View

  className: 'btn-group'

  attributes:
    'data-toggle': 'buttons-radio'

  initialize: ->

    @$el.button()

  render: =>

    for button in @options.items
      @$el.append @renderButton button

    @

  renderButton: (button) =>

    label = button.name ? button.label

    $buttonEl = $(@make 'a', { class: 'btn' }, label)

    if @options.field
      @bindToAndTrigger @model, "change:#{@options.field}", =>
        console.log 'change status'
        $buttonEl.toggleClass 'active', @model.get(@options.field) is button.value
    else
      if button.value is @options.value
        $buttonEl.button 'toggle'

    $buttonEl.click (e) =>

      e.preventDefault()

      if @options.field
        @model.set @options.field, button.value

      @options.select? button.value

    $buttonEl
