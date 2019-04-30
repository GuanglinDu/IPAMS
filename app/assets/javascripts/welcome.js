var width  = 732;
var height = 732;
var radius = Math.min(width, height) / 2;

// Formats the Data
var partition = d3.partition()
	                .size([2 * Math.PI, radius]);

// Calculates each arc
var arc = d3.arc()
            .startAngle(function(d) { return d.x0; })
            .endAngle(function(d) { return d.x1; })
            .innerRadius(function(d) { return d.y0; })
            .outerRadius(function(d) { return d.y1; });

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
  if (cmd == "draw_donut") {
    drawSunburst(data);
  } else if (cmd == "update_page") {
    updatePage(data);
  } else {
    console.log("Unrecognized command: " + cmd);
  }
};

function error() {
  console.log("Something went wrong!");
}

var drawSunburst = function(data) {
  console.log(data);
  //var color = d3.scaleOrdinal(d3.quantize(d3.interpolateRainbow,
  //                                        data.children.length + 1));

  var color = d3.scaleOrdinal()
                .domain(data)
                .range(d3.schemeSet3);

  var svg = d3.select('#chart')
              .append('svg:svg')
              .attr('width', width)
              .attr('height', height)
              .style('width', 'auto')
              .style('height', 'auto')
              .style('font', '10px sans-serif')
              .append('svg:g')
              .attr("id", "container")
              .attr('transform', 'translate(' + (width / 2) + ',' + (height / 2)
                + ')');

  // Bounding circle underneath the sunburst, to make it easier to detect
  // when the mouse leaves the parent g.
  svg.append('svg:circle')
     .attr('r', radius)
     .style('opacity', 0);

  // Finds the Root Node
  var root = d3.hierarchy(data)
               .sum(function(d) { return d.size });

  // For efficiency, filter nodes to keep only those large enough to see.
  // 0.005 radians = 0.29 degrees
  var nodes = partition(root).descendants()
                             .filter(function(d) {
			                         return (d.x1 - d.x0 > 0.005);
			                       });

  svg.selectAll('g')
      .data(nodes)
      .enter()
      .append('svg:g')
      .attr('class', "node")
      .append('svg:path')
      .attr('display', function(d) { return d.depth ? null : 'none'; })
      .attr('d', arc)
      .style('stroke', '#fff')
      .style('fill', function(d) {
	      return color((d.children ? d : d.parent).data.name);
      })
      .style('opacity', 1)
      .on('mouseover', mouseover);

  // Add a Label for Each Node
  svg.selectAll('.node')
     .append('svg:text')
     .attr('transform', function(d) {
     	 return 'translate(' + arc.centroid(d) +
     	        ')rotate(' + computeTextRotation(d) + ')';
     })
     .attr('dx', '6') // margin
     .attr('dy', '.35em')
     .attr('text-anchor', 'middle')
     .style('stroke-width', 5)
     .text(function(d) { return d.parent ? d.data.name : ''; });

  // Add the mouseleave handler to the bounding circle.
  d3.select("#container").on("mouseleave", mouseleave);

  // Fade all but the current sequence, and show it in the breadcrumb trail.
  function mouseover(d) {
    var info = d.data.name + ': ' + d.value;
    d3.select('#statistics').text(info);

    d3.select('#explanation').style('visibility', '');

    var sequenceArray = d.ancestors().reverse();
    sequenceArray.shift(); // remove root node from the array
    //updateBreadcrumbs(sequenceArray, percentageString);

    // Fade all the segments.
    d3.selectAll('path').style('opacity', 0.3);

    // Then highlight only those that are an ancestor of the current segment.
    svg.selectAll('path')
       .filter(function(node){ return sequenceArray.indexOf(node) >= 0; })
       //.filter(function(node) {
       //  return (sequenceArray.indexOf(node) >= 0);
       //})
       .style('opacity', 1);
  }

  // Restore everything to full opacity when moving off the visualization.
  function mouseleave(d) {
    // Hide the breadcrumb trail
    //d3.select("#trail")
    //    .style("visibility", "hidden");

    // Deactivate all segments during transition.
    d3.selectAll("path").on("mouseover", null);

    // Transition each segment to full opacity and then reactivate it.
    d3.selectAll("path")
      .transition()
      .duration(1000)
      .style("opacity", 1)
      .on("end", function() {
              d3.select(this).on("mouseover", mouseover);
      });

    d3.select("#explanation")
      .style("visibility", "hidden");
  }
};

function computeTextRotation(d) {
  var angle = (d.x0 + d.x1) / Math.PI * 90;
  // Avoids upside-down labels. Labels aligned with slices.
  //return (angle < 90 || angle > 270) ? angle : angle + 180;

  // Alternate label formatting, in the radian direction
  return (angle < 180) ? angle - 90 : angle + 90;
}


var updatePage = function(data) {
};

