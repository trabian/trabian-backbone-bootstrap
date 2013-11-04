template = require './template'

module.exports = class Modal extends Backbone.View

  className: 'modal'

  events: (others = {}) ->
    _.extend {}, others,
      'click a.close-modal': 'hide'

  initialize: ->
    @$el.modal()

  render: =>

    locals =
      title: @options.title

    @$el.html template locals

    @renderHeader @$('.heading')
    @renderContent @$('.modal-body')
    @renderFooter @$('.modal-footer')

    @

  renderHeader: ($el) =>
    # Do nothing

  renderContent: ($el) =>
    $el.html '[content]'

  renderFooter: ($el) =>
    $el.append '<a class="btn close close-modal">Close</a>'

  open: =>
    @$el.modal 'show'

  hide: =>
    @$el.modal 'hide'
