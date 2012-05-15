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

    if button.value is @options.value
      $buttonEl.button 'toggle'

    $buttonEl.click (e) =>

      e.preventDefault()

      @options.select? button.value

    $buttonEl
