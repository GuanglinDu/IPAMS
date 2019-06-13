// In-place editing via x-editable-rails
$(function() {
  return $("[data-xeditable=true]").each(function() {
    return $(this).editable({
      ajaxOptions: {
        type: "PUT",
        dataType: "json"
      },
      params: function(params) {
        var railsParams = {};
        railsParams[$(this).data("model")] = {};
        railsParams[$(this).data("model")][params.name] = params.value;
        return railsParams;
      },
      success: function(response) {
        var cellName = $(this).closest("td").attr("id");
        var rowID = $(this).closest("tr").attr("id");
        return $(this).trigger('onAfterUpdate', [rowID, cellName, response]);
      }
    });
  });
})

var showLanStats = function(locale, lan_id) {
  $.ajax({
    type: 'GET',
    contentType: 'application/json; charset=utf-8',
    url: '/' + locale.to_s + '/lans/' + lan_id,
    dataType: 'json',
    success: function(data) { drawVlansBarChart(data); }, 
    failure: function(result) { 
      console.log("Something went wrong in function showAddressesStatus!");
    }
  });
};

// var data = [
//   {vlan_name: "VLAN1", used: 472, free: 552},
//   {vlan_name: "VLAN2", used: 769, free: 255},
//   {vlan_name: "VLAN3", used: 156, free: 100},
//   {vlan_name: "VLAN4", used: 972, free: 52},
//   {vlan_name: "VLAN5", used: 28, free: 100},
//   {vlan_name: "VLAN6", used: 56, free: 200},
//   {vlan_name: "VLAN7", used: 96, free: 32},
//   {vlan_name: "VLAN8", used: 322, free: 702}
// ];
var drawVlansBarChart = function(data) {
  var keys = ["used", "free"];
  // Dimensions of legend item: width, height, spacing, radius of rounded rect
  var li = {
    w: 75, h: 30, s: 3, r: 3
  };

  var vlans = data.map(function(d) { return d.vlan_name; });
  var margin = {top: 50, left: 50, bottom: 80, right: 50};

  var chartDiv = document.getElementById("lan-chart");
  var width = chartDiv.clientWidth - margin.left - margin.right;

  var svg = d3.select("#lan-bar-chart")
              .attr("width", chartDiv.clientWidth);
  var height = +svg.attr("height") - margin.top - margin.bottom;

  var y = d3.scaleLinear()
            .rangeRound([height + margin.top, margin.top]);

  //Note: The acute (back quote ``) is not supported in the production mode!
  var offset = height + margin.top;
  var xAxis = svg.append("g")
                 .attr("transform", "translate(0," + offset + ")")
                 .attr("class", "x-axis");

  var yAxis = svg.append("g")
                 .attr("transform", "translate(" + margin.left + ",0)")
                 .attr("class", "y-axis");

  var colors = {used: "green", free: "red"};
  var z = d3.scaleOrdinal()
            .range(Object.values(colors)) // used, free
            .domain(keys);

  update(data, 0);
  
  // 0. Appends the legend SVG element (intialization)
  d3.select("#lan-bar-chart-legend")
    .append("svg:svg")
    .attr("class", "legend");
  drawLegend();
  
  window.addEventListener("resize", updateClientWidth);

  function update(data, speed) {
    data.forEach(function(d) {
      d.ratio = d.free + "/" + d.used;
      d.total = parseInt(d.free) + parseInt(d.used);
      return d;
    })

    var x = d3.scaleBand()
              .range([margin.left, width + margin.left])
              .padding(0.1);
    y.domain([0, d3.max(data, function(d) { return d.total; })]).nice();

    svg.selectAll(".y-axis").transition().duration(speed)
       .call(d3.axisLeft(y).ticks(null, "s"));

    data.sort(d3.select("#vlan-sort").property("checked")
      ? function(a, b) { return b.total - a.total; }
      : function(a, b) {
          return vlans.indexOf(a.vlan_name) - vlans.indexOf(b.vlan_name);
        });

    x.domain(data.map(function(d) { return d.vlan_name; }));

    svg.selectAll(".x-axis").transition().duration(speed)
       .call(d3.axisBottom(x).tickSizeOuter(0))
       .selectAll("text")  
       .style("text-anchor", "end")
       .style("font-size", "12px")        
       .attr("dx", "-.8em")
       .attr("dy", ".15em")
       .attr("transform", "rotate(-65)");

    var group = svg.selectAll("g.layer")
      .data(d3.stack().keys(keys)(data), function(d) { return d.key; });

    group.exit().remove();

    group.enter().append("g")
        .classed("layer", true)
        .attr("fill", function(d) { return z(d.key); });

    var bars = svg.selectAll("g.layer").selectAll("rect")
      .data(function(d) { return d; }, function(e) { return e.data.vlan_name; });

    bars.exit().remove();

    bars.enter().append("rect")
        .attr("width", x.bandwidth())
        .merge(bars)
        .transition().duration(speed)
        .attr("x", function(d) { return x(d.data.vlan_name); })
        .attr("y", function(d) { return y(d[1]); })
        .attr("height", function(d) { return y(d[0]) - y(d[1]); });

    var text = svg.selectAll(".text")
                  .data(data, function(d) { return d.vlan_name; });

    text.exit().remove();

    text.enter().append("text")
        .attr("class", "text")
        .attr("text-anchor", "middle")
        .merge(text)
        .transition().duration(speed)
        .style("fill", "black")
        .style("font-size", "12px")
        .attr("dy", ".35em")
        .attr("text-anchor", "middle")
        .attr("transform", function(d, i) {
          return "translate(" + (x(d.vlan_name) + x.bandwidth() / 2)
                 + "," + (y(d.total) - 30) + ") " + "rotate(-70)";
        })
        .text(function(d) { return d.ratio; });
  }

  var checkbox = d3.select("#vlan-sort")
                   .on("click", function() {
      update(data, 750);
    });

  function drawLegend() {
    // 1. Joins data to all groups of the legend
    var legend = d3.select(".legend")
                   .attr("width", (li.w + li.s) * 2 )
                   .attr("height", li.h)
                   .selectAll("g")
                   .data(d3.entries(colors));

    // 2. Exits and removes to get rid of any redundant DOM elements
    legend.exit().remove();

    // 3. Enters & appends a group — making sure you assign the same class
    var entering = legend.enter().append("svg:g");

    // 4. Appends the DOM elements you need to the group
    entering.append("svg:rect")
     .attr("rx", li.r)
     .attr("ry", li.r)
     .attr("width", li.w)
     .attr("height", li.h)
     .style("fill", function(d) { return d.value; });

    entering.append("svg:text")
     .attr("x", li.w / 2)
     .attr("y", li.h / 2)
     .attr("dy", "0.35em")
     .attr("text-anchor", "middle")
     .text(function(d) { return d.key; });

    // 5. Merges groups
    entering.merge(legend)
            .attr("transform", function(d, i) {
              return "translate(" + i * (li.w + li.s) + ",0)";
            });
  }

  // Redraws the stacked bar chart after the window resizes.
  function updateClientWidth() {
    chartDiv = document.getElementById("lan-chart");
    width = chartDiv.clientWidth - margin.left - margin.right;

    svg = d3.select("#lan-bar-chart")
            .attr("width", chartDiv.clientWidth);

    x = d3.scaleBand()
          .range([margin.left, width + margin.left])
          .padding(0.1);

    update(data, 750);
    drawLegend();    
  }
};
