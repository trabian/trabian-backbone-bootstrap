module.exports = class ButtonGroup extends Backbone.View

  attributes:
    'data-toggle': 'buttons-radio'

  initialize: ->

    @options.group ?= true

    if @options.group
      @$el.addClass 'btn-group'

    @$el.attr
      name: @options.field

    @$el.button()

  render: =>

    if @options.dropdown

      # Setting id to field name allows model binding
      @$el.html $dropdown = $("<select id='#{@options.field}'></select>")

      for button in @options.items
        $dropdown.append @renderOption button

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

      if @options.field
        @model.set @options.field, value

      @options.select? value

    $buttonEl

  renderOption: (button) =>

    label = button.name ? button.label
    value = button.key ? button.label

    $optionEl = $(@make 'option', { value }, label)

    $optionEl
