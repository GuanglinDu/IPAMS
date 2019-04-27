var width  = 750;
var height = 600;
var radius = Math.min(width, height) / 2;
var donutWidth = 100;

var loadData = function(cmd) {
  $.ajax({
    type: 'GET',
    contentType: 'application/json; charset=utf-8',
    url: '/welcome',
    dataType: 'json',
    success: function(data) { drawOrUpdate(data, cmd); }, 
    failure: function(result) { error(); }
  });
};

var drawOrUpdate = function(data, cmd) {
  //console.log(data);
  if (cmd == "draw_donut") {
    drawDonut(data);
  } else if (cmd == "update_page") {
    updatePage(data);
  } else {
    console.log("Unrecognized command: " + cmd);
  }
};

function error() {
  console.log("Something went wrong!");
}

var drawDonut = function(data) {
  //var color = d3.scaleOrdinal(d3.quantize(d3.interpolateRainbow,
  //                                        data.children.length + 1));
  var color = d3.scaleOrdinal()
                .domain(data)
                .range(d3.schemeSet3);

  var svg = d3.select('#chart')
    .append('svg')
    .attr('width', width)
    .attr('height', height)
    .append('g')
    .attr('transform', 'translate(' + (width / 2) + ',' + (height / 2) + ')');

  // Formats the Data
  var partition = d3.partition()
		    .size([2 * Math.PI, radius * radius]);

  // Finds the Root Node
  var root = d3.hierarchy(data)
	       .sum(function(d) { return d.size });

  // For efficiency, filter nodes to keep only those large enough to see.
  var nodes = partition(root).descendants()
      .filter(d => (d.x1 - d.x0 > 0.005)); // 0.005 radians = 0.29 degrees

  // Calculates each arc
  var arc = d3.arc()
              .startAngle(function(d) { return d.x0; })
              .endAngle(function(d) { return d.x1; })
              .innerRadius(function(d) { return Math.sqrt(d.y0); })
              .outerRadius(function(d) { return Math.sqrt(d.y1); });

  svg.selectAll('g')
      .data(nodes)
      .enter()
      .append('g')
      .attr("class", "node")
      .append('path')
      .attr("display", function(d) { return d.depth ? null : "none"; })
      .attr("d", arc)
      .style('stroke', '#fff')
      .style("fill", function(d) {
	 return color((d.children ? d : d.parent).data.name);
      });

  // Add a Label for Each Node
  svg.selectAll(".node")
     .append("text")
     .attr("transform", function(d) {
	return "translate(" + arc.centroid(d)
		            + ")rotate("
                            + computeTextRotation(d) + ")";
     })
     .attr("dx", "-50")
     .attr("dy", ".5em")
     .text(function(d) { return d.parent ? d.data.name : ""; });
};

function computeTextRotation(d) {
    var angle = (d.x0 + d.x1) / Math.PI * 90;  // <-- 1
    // Avoids upside-down labels. Labels aligned with slices.
    return (angle < 90 || angle > 270) ? angle : angle + 180;
    // Alternate label formatting
    //return (angle < 180) ? angle - 90 : angle + 90;  // <-- 3 "labels as spokes"
}

var updatePage = function(data) {
};

//loadData("draw_donut");
