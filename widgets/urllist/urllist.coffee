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
      if element.value == "200"
        $(g[index]).css('background-color', 'green')
      else if element.value == "404"
        $(g[index]).css('background-color', 'red')
      else if element.value == false
        $(g[index]).css('background-color', 'red')



