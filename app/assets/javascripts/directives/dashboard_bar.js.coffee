App.directive 'dashboardBar', [ ->
  scope: {
  }
  restrict: 'E'

  link: (scope, element, attributes) ->
    console.log element
    scope.maxCount = parseInt(attributes['maxCount'])
    scope.count = parseInt(attributes['count'])

    renderBar = ->
      svg = d3.select(element[0].parentNode)
      violationBarWidth = parseFloat(svg.style("width"))

      yScale = d3.scale.linear()
        .domain([0, scope.maxCount])
        .range([0, violationBarWidth])

      svg
        .attr("width", violationBarWidth)
        .append('rect')
        .attr(
          x: 0
          y: 0
          width: yScale(scope.count)
          height: 20
        )

    scope.$watch 'count', (newValue, oldValue) =>
      if newValue
        renderBar()
]
