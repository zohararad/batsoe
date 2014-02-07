class Batsoe.MainIndexView extends Batman.View
  resetName: ->
    @controller.set('firstName', '')
    @controller.set('lastName', '')

  @accessor 'hasName', ->
    @controller.get('fullName').length > 1
