$ ->
  costs = $.parseJSON(gon.costs)
  xaxis = []
  graphdatasets = []

  fillColorRed   = 0x00
  fillColorGreen = 0x00
  fillColorBlue  = 0x00
  lp = 0
  $.each(costs, (category, data) ->
    if lp % 3 == 0
      fillColorRed = fillColorRed + 125
    else if lp % 3 == 1
      fillColorGreen = fillColorGreen + 125
    else if lp % 3 == 2
      fillColorBlue = fillColorBlue + 125

    console.log fillColorRed
    console.log fillColorGreen
    console.log fillColorBlue
    graphdata = []
    graphdata.label         = category
    graphdata.fillColor     = "rgba(#{fillColorRed}, #{fillColorGreen}, #{fillColorBlue},0.5)"
    graphdata.strokeColor   = "rgba(0,0,0,1)"
    graphdata.highlightFill = "rgba(100,220,220,0.75)"
    graphdata.data          = data
    graphdatasets.push graphdata
    lp = lp + 1
  )

  data = {
    labels: gon.months,
    datasets: graphdatasets
  };
  Chart.defaults.global.multiTooltipTemplate = "<%if (datasetLabel){%><%=datasetLabel%>: <%}%><%= value %>"
  ctx = document.getElementById("cost_graph_canvas").getContext("2d")
  graph = new Chart(ctx).StackedBar(data, {
    barStrokeWidth: 1
  })
