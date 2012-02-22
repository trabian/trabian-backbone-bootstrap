template = require './template'

module.exports = class Modal extends Backbone.View

  className: 'modal'

  events:
    'click a.close': 'hide'

  initialize: ->
    @$el.modal()

  render: =>

    locals =
      title: @options.title

    @$el.html template locals

    @renderContent @$('.modal-body')
    @renderFooter @$('.modal-footer')

    @

  renderContent: ($el) =>
    $el.html '[content]'

  renderFooter: ($el) =>
    $el.append @make 'a', { class: 'btn close' }, 'Close'

  open: =>
    @$el.modal 'show'

  hide: =>
    @$el.modal 'hide'
