#violationBar = d3.selectAll(".violation-bar")
#violationBarWidth = parseFloat(violationBar.style("width"))
#violationBar.select("svg").attr("width", violationBarWidth)
#
#maxViolationsCount = 2300 # d3.max(violationCounts, (d) -> d[1])
#
#yScale = d3.scale.linear()
#  .domain([0, maxViolationsCount])
#  .range([0, violationBarWidth])
#
#violationBar.each (index) ->
#  violationCount = d3.select(this)
#    .attr("data-violation_count")
#
#  d3.select(this)
#    .select("svg")
#    .append("rect")
#    .attr(
#      x: 0
#      y: 0
#      width: yScale(violationCount)
#      height: 20
#    )
