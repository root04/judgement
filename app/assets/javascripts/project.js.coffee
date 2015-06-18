$ ->
  costs = $.parseJSON(gon.costs)
  xaxis = []
  graphdatasets = []

  $.each(costs, (category, data) ->
    graphdata = []
    graphdata.label         = category
    graphdata.fillColor     = "rgba(220,220,220,0.5)"
    graphdata.strokeColor   = "rgba(220,220,220,0.8)"
    graphdata.highlightFill = "rgba(220,220,220,0.75)"
    graphdata.data          = data
    graphdatasets.push graphdata
  )

  data = {
    labels: gon.months,
    datasets: graphdatasets
  };
  ctx = document.getElementById("cost_graph_canvas").getContext("2d")
  graph = new Chart(ctx).StackedBar(data)
