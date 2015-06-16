$ ->
  costs = $.parseJSON(gon.costs)
  graphData = []
  xaxis = []
  console.log costs
  $.each(costs, (k, v) ->
    xaxis.push k
    graphData.push v
  )

  data = {
    labels: xaxis,
    datasets: [
      {
        label: "My First dataset",
        fillColor: "rgba(220,220,220,0.5)",
        strokeColor: "rgba(220,220,220,0.8)",
        highlightFill: "rgba(220,220,220,0.75)",
        highlightStroke: "rgba(220,220,220,1)",
        data: graphData
      }
    ]
  };
  ctx = document.getElementById("cost_graph_canvas").getContext("2d")
  graph = new Chart(ctx).Bar(data)
