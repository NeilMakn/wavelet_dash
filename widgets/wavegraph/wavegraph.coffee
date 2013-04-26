class Dashing.Wavegraph extends Dashing.Widget

  @accessor 'current', ->
    return @get('displayedValue') if @get('displayedValue')
    points = @get('points')
    if points
      points[points.length - 1].y

  ready: ->
    palette = new Rickshaw.Color.Palette({ scheme: 'colorwheel' })
    container = $(@node).parent()

    myPoints = @get('series') if @get('series')
    testSeries = []
    for element, index in myPoints
      temp = {
        data: element,
        color: palette.color()
      }
      testSeries[index] = temp

    # Gross hacks. Let's fix this.
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))
    @graph = new Rickshaw.Graph(
      element: @node
      width: width
      height: height
      min: 'auto'
      renderer: 'line'
      series: testSeries
    )

    x_axis = new Rickshaw.Graph.Axis.Time(graph: @graph)
    y_axis = new Rickshaw.Graph.Axis.Y(graph: @graph, tickFormat: Rickshaw.Fixtures.Number.formatKMBT)
    @graph.render()

  onData: (data) ->
    if @graph
      for element, index in @graph.series
        @graph.series[index].data = data.series[index]
      @graph.render()
