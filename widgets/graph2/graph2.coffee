class Dashing.Graph2 extends Dashing.Graph

  ready: ->
    super()

  onData: (data) ->
    super(data)
    if data.derivative >= 1
      $(@node).css('background-color', 'red')
