class Dashing.Threshold extends Dashing.Widget
  @accessor 'current', Dashing.AnimatedValue



  @accessor 'difference', ->
    if @get('last')
      last = parseInt(@get('last'))
      current = parseInt(@get('current'))
      if last != 0
        diff = Math.abs(Math.round((current - last) / last * 100))
        "#{diff}%"
    else
      ""

  @accessor 'arrow', ->
    if @get('last')
      if parseInt(@get('current')) > parseInt(@get('last')) then 'icon-arrow-up' else 'icon-arrow-down'

  # ready: ->
  #   # if @get('operator') == 'greater'
  #   #   console.log('true')
  #   # else
  #   #   console.log('false')

  onData: (data) ->
    # console.log(data.current, data.threshold)
    if data.status
      # clear existing "status-*" classes
      $(@get('node')).attr 'class', (i,c) ->
        c.replace /\bstatus-\S+/g, ''
      # add new class
      $(@get('node')).addClass "status-#{data.status}"
    if @get('operator') == 'greater' && data.current >= data.threshold
      $(@node).css('background-color', 'red')
    else if @get('operator') == 'lesser' && data.current <= data.threshold
      $(@node).css('background-color', 'red')

