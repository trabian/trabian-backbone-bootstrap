module.exports = class ButtonGroup extends Backbone.View

  className: 'btn-group'

  events:
    'change select': 'changeSelect'

  attributes:
    'data-toggle': 'buttons-radio'

  initialize: ->

    @$el.button()

  render: =>

    if @options.select

      @$el.html $select = $('<select></select>')

      for button in @options.items
        $select.append @renderOption button

    else

      for button in @options.items
        @$el.append @renderButton button

    @

  renderButton: (button) =>

    label = button.name ? button.label
    value = button.key ? button.label

    $buttonEl = $(@make 'a', { class: 'btn' }, label)

    if @options.field
      @bindToAndTrigger @model, "change:#{@options.field}", =>
        $buttonEl.toggleClass 'active', @model.get(@options.field) is value
    else
      if value is @options.value
        $buttonEl.button 'toggle'

    $buttonEl.click (e) =>
      e.preventDefault()
      @setValue value

    $buttonEl

  renderOption: (button) =>

    label = button.name ? button.label
    value = button.key ? button.label

    $optionEl = $(@make 'option', { value }, label)

    $optionEl

  setValue: (value) =>

    if @options.field
      @model.set @options.field, value

    @options.select? value

  changeSelect: (e) =>
    @setValue $(e.target).val()
