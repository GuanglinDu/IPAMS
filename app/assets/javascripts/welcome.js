var svgBox, width, height, radius, originalData;

// Breadcrumb dimensions: width, height, spacing, width of tip/tail
var b = {
  w: 160, h: 30, s: 3, t: 10
};

//var chartDiv = document.getElementById("chart");
//var svg = d3.select("div#chart").append('svg:svg');

// Calculates each arc
var arc = d3.arc()
            .startAngle(function(d) { return d.x0; })
            .endAngle(function(d) { return d.x1; })
            .innerRadius(function(d) { return d.y0; })
            .outerRadius(function(d) { return d.y1; });

//var svg = d3.select('div#chart').append('svg:svg');

var loadData = function(locale, cmd) {
  $.ajax({
    type: 'GET',
    contentType: 'application/json; charset=utf-8',
    url: '/' + locale.to_s + '/welcome',
    dataType: 'json',
    success: function(data) { drawOrUpdate(data, cmd); }, 
    failure: function(result) { error(); }
  });
};

var drawOrUpdate = function(data, cmd) {
  originalData = data;

  if (cmd == "drawSunburst") {
    drawSunburst(data);
  } else if (cmd == "updateSunburst") {
    updatePage();
  } else {
    console.log("Unrecognized command: " + cmd);
  }

  // Redraws based on the new size whenever the browser window is resized
  window.addEventListener("resize", updatePage);
};

function error() {
  console.log("Something went wrong!");
}

var drawSunburst = function(data) {
  //console.log(data);
  svgBox = document.querySelector("div#chart");
  width  = svgBox.clientWidth;
  height = svgBox.clientHeight;
  radius = Math.min(width, height) / 2;

  // Sets the explanation div position
  var leftOffset =  width / 2 - 70;
  d3.select("#explanation").style("left", leftOffset + "px");

  // Formats the Data
  var partition = d3.partition()
	                  .size([2 * Math.PI, radius]);

  // Basic setup of page elements.
  initializeBreadcrumbTrail();

 // var color = d3.scaleOrdinal(d3.quantize(d3.interpolateRainbow,
 //                                         data.children.length + 1));

  var color = d3.scaleOrdinal()
                .domain(data)
                .range(d3.schemeSet3);

  var svg = d3.select('div#chart')
              .append('svg:svg')
              .attr('width', width)
              .attr('height', height)
              .style('font', '12px sans-serif')
              .append('svg:g')
              .attr("id", "container")
              .attr("transform", "translate(" + width/2 + "," + height/2 + ")");

  // Bounds circle underneath the sunburst, to make it easier to detect
  // when the mouse leaves the parent g.
  svg.append('svg:circle')
     .attr('r', radius)
     .style('opacity', 0);

  // Finds the Root Node
  var root = d3.hierarchy(data)
               .sum(function(d) { return d.size });

  // For efficiency, filters nodes to keep only those large enough to see
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

    // Adds a Label for Each Node
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

    // Adds the mouseleave handler to the bounding circle.
  d3.select("#container").on("mouseleave", mouseleave);

  // Fades all but the current sequence, and show it in the breadcrumb trail
  function mouseover(d) {
    var info = d.data.name + ' (' + d.value + " IPs)";
    d3.select('#statistics').text(info);

    d3.select('#explanation').style('visibility', '');

    var sequenceArray = d.ancestors().reverse();
    sequenceArray.shift(); // remove root node from the array
    updateBreadcrumbs(sequenceArray, d.data.name);

    // Fades all the segments.
    d3.selectAll('path').style('opacity', 0.3);

    // Then highlights only those that are an ancestor of the current segment
    svg.selectAll('path')
       .filter(function(node){ return sequenceArray.indexOf(node) >= 0; })
       //.filter(function(node) {
       //  return (sequenceArray.indexOf(node) >= 0);
       //})
       .style('opacity', 1);
  }

  // Restores everything to full opacity when moving off the visualization
  function mouseleave(d) {
    // Hides the breadcrumb trail
    d3.select("#trail").style("visibility", "hidden");

    // Deactivates all segments during transition.
    d3.selectAll("path").on("mouseover", null);

    // Transitions each segment to full opacity and then reactivate it
    d3.selectAll("path")
      .transition()
      .duration(1000)
      .style("opacity", 1)
      .on("end", function() {
        d3.select(this).on("mouseover", mouseover);
      });

    d3.select("#explanation").style("visibility", "hidden");
  }

  // Updates the breadcrumb trail to show the current sequence and percentage
  function updateBreadcrumbs(nodeArray, info) {
    // Data join; key function combines name and depth (= position in sequence)
    var trail = d3.select("#trail")
        .selectAll("g")
        .data(nodeArray, function(d) { return d.data.name + d.depth; });

    // Removes exiting nodes.
    trail.exit().remove();

    // Adds breadcrumb and label for entering nodes
    var entering = trail.enter().append("svg:g");

    entering.append("svg:polygon")
        .attr("points", breadcrumbPoints)
        .style("fill", function(d) {
          return color((d.children ? d : d.parent).data.name)
        });

    entering.append("svg:text")
        .attr("x", (b.w + b.t) / 2)
        .attr("y", b.h / 2)
        .attr("dy", "0.35em")
        .attr("text-anchor", "middle")
        .text(function(d) { return d.data.name; });

    // Merges enter and update selections; set position for all nodes
    entering.merge(trail).attr("transform", function(d, i) {
      return "translate(" + i * (b.w + b.s) + ", 0)";
    });

    // Now moves and updates the percentage at the end.
    d3.select("#trail").select("#endlabel")
        .attr("x", (nodeArray.length + 0.5) * (b.w + b.s))
        .attr("y", b.h / 2)
        .attr("dy", "0.35em")
        .attr("text-anchor", "middle")
        .text(info);

    // Make the breadcrumb trail visible, if it's hidden
    d3.select("#trail").style("visibility", "");
  }
};

function computeTextRotation(d) {
  var angle = (d.x0 + d.x1) / Math.PI * 90;
  // Avoids upside-down labels. Labels aligned with slices.
  //return (angle < 90 || angle > 270) ? angle : angle + 180;

  // Alternate label formatting, in the radian direction
  return (angle < 180) ? angle - 90 : angle + 90;
}

function initializeBreadcrumbTrail() {
  // Adds the svg area.
  var trail = d3.select("#sequence").append("svg:svg")
                .attr("width", width)
                .attr("id", "trail");
  // Adds the label at the end, for the percentage.
  trail.append("svg:text")
       .attr("id", "endlabel")
       .style("fill", "#000");
}

// Generates a string that describes the points of a breadcrumb polygon
function breadcrumbPoints(d, i) {
  var points = [];
  points.push("0,0");
  points.push(b.w + ",0");
  points.push(b.w + b.t + "," + (b.h / 2));
  points.push(b.w + "," + b.h);
  points.push("0," + b.h);
  if (i > 0) { // Leftmost breadcrumb; don't include 6th vertex
    points.push(b.t + "," + (b.h / 2));
  }
  return points.join(" ");
}

// Redraws the chart after the window was resized.
var updatePage = function() {
  d3.selectAll("svg").remove();

  svgBox = document.querySelector("div#chart");
  width  = svgBox.clientWidth;
  height = svgBox.clientHeight;
  radius = Math.min(width, height) / 2;
  drawSunburst(originalData);
};

// Initializes: draw the first time here or in welcome#index
//loadData(gon.locale, "drawSunburst");
