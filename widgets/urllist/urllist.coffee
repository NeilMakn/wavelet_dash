class Dashing.Urllist extends Dashing.Widget

  ready: ->
    Dashing.debugMode = false
    if @get('unordered')
      $(@node).find('ol').remove()
    else
      $(@node).find('ul').remove()

  onData: (data) ->
    g = $(@node).find('li')

    # change background for list item depending on HTTP return code
    for element, index in data.items
      switch element.value
        when "200" then $(g[index]).css('background-color', 'green')
        when "404" then $(g[index]).css('background-color', 'red')
        when false then $(g[index]).css('background-color', 'red')
        else $(g[index]).css('background-color', 'gray')
