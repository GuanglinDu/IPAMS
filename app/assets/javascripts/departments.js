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
        railsParams[$(this).data("model")][params.name] = params.user_count;
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

var showDepartmentStats = function(locale) {
  $.ajax({
    type: 'GET',
    contentType: 'application/json; charset=utf-8',
    url: '/' + locale.to_s + '/departments/',
    dataType: 'json',
    success: function(data) { drawDepartmentBar(data); },
    failure: function(result) {
      console.log("Something went wrong in function showDepartmentStatus!");
    }
  });
};
    
//var datademo = [{dept_name:"department_1953", user_count: 55},{dept_name:"department_1954", user_count: 57},{dept_name:"department_1955", user_count: 143},{dept_name:"department_1956", user_count: 77},{dept_name:"department_1957", user_count: 57},{dept_name:"department_1958", user_count: 37},{dept_name:"department_1959", user_count: 83},{dept_name:"department_1960", user_count: 55},{dept_name:"department_1961", user_count: 57},{dept_name:"department_1962", user_count: 60},{dept_name:"department_1963", user_count: 50},{dept_name:"department_1964", user_count: 57},{dept_name:"department_1965", user_count: 7},{dept_name:"department_1966", user_count: 91},{dept_name:"department_1967", user_count: 55},{dept_name:"department_1968", user_count: 57},{dept_name:"department_1969", user_count: 43},{dept_name:"department_1970", user_count: 77},{dept_name:"department_1971", user_count: 57},{dept_name:"department_1972", user_count: 57},{dept_name:"department_1973", user_count: 93},{dept_name:"department_1974", user_count: 55},{dept_name:"department_1975", user_count: 57},{dept_name:"department_1976", user_count: 60},{dept_name:"department_1977", user_count: 50},{dept_name:"department_1978", user_count: 57},{dept_name:"department_1979", user_count: 7},{dept_name:"department_1980", user_count: 91},{dept_name:"department_1981", user_count: 19},{dept_name:"department_1982", user_count: 37},{dept_name:"department_1983", user_count: 47},{dept_name:"department_1984", user_count: 237},{dept_name:"department_1985", user_count: 67},{dept_name:"department_1986", user_count: 64},{dept_name:"department_1987", user_count: 182},{dept_name:"department_1988", user_count: 7},{dept_name:"department_1989", user_count: 67},{dept_name:"department_1990", user_count: 55},{dept_name:"department_1991", user_count: 57}];
                    
//var margin = {top: 40, right: 30, bottom: 180, left: 50};

var drawDepartmentBar = function(dataset){

  var chartDiv = document.getElementById("lan-chart-div");
  var margin = {top: 40, right: 30, bottom: 180, left: 50};
  var svg = d3.select("#lan-chart")
              .attr("width", chartDiv.clientWidth);
  var width = +svg.attr("width") - margin.left - margin.right;
  var height = +svg.attr("height") - margin.top - margin.bottom;
  
  var x;
  var xAxis;
  var y = d3.scaleLinear().range([height + margin.top, margin.top]);
  y.domain([0, d3.max(dataset, function(d) { return d.user_count; })]);

  var yAxis = d3.axisLeft(y).tickFormat(formatPercent);

  var formatPercent = d3.format("d");


  function update(dataset) {
    x = d3.scaleBand()
          .range([margin.left, width + margin.left])
          .padding(0.1);

    svg.append("g")
       .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
    
    xAxis = d3.axisBottom(x).tickSizeOuter(0);
    x.domain(dataset.map(function(d) { return d.dept_name; }));

    var h = margin.top + height;
    
    svg.append("g")
       .attr("class", "x axis")
       .attr("transform", "translate(0," + h + ")")
       .call(xAxis)
       // .selectAll("text")
       // .data(dataset)

  var text = svg.call(xAxis).selectAll("text")
                .data(dataset)
       
       text.exit().remove();

       text.enter().append("text")
       .attr("class", "text")
       .merge(text)
       .attr("y", 0)
       .attr("x", 9)
       .attr("dy", ".35em")
       .attr("transform", "rotate(75)")
       .style("text-anchor", "start");
            
    svg.append("g")
       .attr("class","y axis")
       .attr("transform", "translate(" + margin.left + ",0)")
       .call(yAxis);

    /* I. Bars */

    // 1. Joins data
    var bars = svg.selectAll(".bar").data(dataset);
    
    // 2. Exits and removes to get rid of any redundant DOM elements
    bars.exit().remove(); 
   
    // 3. Enters & appends a group — making sure you assign the same class
    // 4. Appends the DOM elements you need to the group
    // 5. Merges groups    
    bars.enter().append("rect")
        .merge(bars)
        .attr("class", "bar")
        .style("display", function(d) { return d.user_count === null ? "none" : null; })
        .style("fill",  "#861930")
        .attr("x",  function(d) { return x(d.dept_name); })
        .attr("width", x.bandwidth())
        // .attr("y",  d => { return height; })
        // .attr("height", 0)
        .transition().duration(750)
        .delay(function(d, i) { return i * 50; })
        .attr("y",  function(d) { return y(d.user_count); })
        .attr("height",  function(d) { return height + margin.top - y(d.user_count); });
    
    /* II. Labels */

    // 1. Joins data
    var labels = svg.selectAll(".label").data(dataset);

    // 2. Exits and removes to get rid of any redundant DOM elements
    labels.exit().remove(); 

    // 3. Enters & appends a group — making sure you assign the same class
    // 4. Appends the DOM elements you need to the group
    // 5. Merges groups    
    // labels is the.user_count of rect bars
    labels.enter().append("text")
          .merge(labels)
          .attr("class", "label")
          .style("display",  function(d) { return d.user_count === null ? "none" : null; })
          .attr("x", ( function(d) { return x(d.dept_name) + (x.bandwidth() / 2) -8 ; }))
          .style("fill",  "#898989")
          .style("font-size", "12px")
          .attr("y",  function(d) { return height; })
          .attr("height", 0)
          .transition().duration(750)
          .delay(function(d, i) { return i * 50; })
          .text( function(d) { return formatPercent(d.user_count); })
          .attr("y",  function(d) { return y(d.user_count) + .1; })
          .attr("dy", "-.8em");
  }
  
  update(dataset);

  window.addEventListener("resize", updateClientWidth);

  function updateClientWidth() {
    svg = d3.select("#lan-chart")
            .attr("width", chartDiv.clientWidth);
    width = +svg.attr("width") - margin.left - margin.right;

    update(dataset);

    div_legend = d3.select("#lan-bar-chart-legend")
                   .attr("width", window.innerWidth);
  }
}
