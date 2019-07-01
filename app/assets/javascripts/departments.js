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
                    
var margin = {top: 40, right: 30, bottom: 180, left: 50};

var drawDepartmentBar = function(dataset){

    var width = 1600 - margin.left - margin.right;
    var height = 800 - margin.top - margin.bottom;

    //var greyColor = "#898989";
    //var barColor = d3.interpolateInferno(0.4);
    //var highlightColor = d3.interpolateInferno(0.3);

    //var formatPercent = d3.format(".0%");
	var formatPercent = d3.format("d");

    //var svg = d3.select("body").append("svg")
    var svg = d3.select("#department-stats")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
    .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var x = d3.scaleBand()
        .range([0, width])
            .padding(0.4);
    var y = d3.scaleLinear()
        .range([height, 0]);

    var xAxis = d3.axisBottom(x).tickSize([]).tickPadding(10);
    //var yAxis = d3.axisLeft(y).tickFormat(formatPercent);
    var yAxis = d3.axisLeft(y).tickFormat(formatPercent);
    //var yAxis = d3.axisLeft();

    x.domain(dataset.map( d => { return d.dept_name; }));
    // y.domain([0, d3.max(dataset,  d => { return d.user_count; })]);
    y.domain([0, d3.max(dataset,  d => { return d.user_count; })]);

    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis)
        .selectAll("text")
            .attr("y", 0)
            .attr("x", 9)
            .attr("dy", ".35em")
            .attr("transform", "rotate(75)")
            .style("text-anchor", "start");
            
    svg.append("g")
        .attr("class","y axis")
        .call(yAxis);
        

    svg.selectAll(".bar")
        .data(dataset)
        .enter().append("rect")
        .attr("class", "bar")
        .style("display", d => { return d.user_count === null ? "none" : null; })
        .style("fill",  "yellow")
        .attr("x",  d => { return x(d.dept_name); })
        .attr("width", x.bandwidth())
        .attr("y",  d => { return height; })
        .attr("height", 0)
        .transition()
        .duration(320)
            .delay(function (d, i) {
                    return i * 10;
                })
        .attr("y",  d => { return y(d.user_count); })
        .attr("height",  d => { return height - y(d.user_count); });

    svg.selectAll(".label")        
        .data(dataset)
        .enter()
        .append("text")
        .attr("class", "label")
        .style("display",  d => { return d.user_count === null ? "none" : null; })
        .attr("x", ( d => { return x(d.dept_name) + (x.bandwidth() / 2) -8 ; }))
        .style("fill",  "#898989")
        .attr("y",  d => { return height; })
        .attr("height", 0)
        .transition()
        .duration(320)
        .delay((d, i) => { return i * 10; })
        .text( d => { return formatPercent(d.user_count); })
        .attr("y",  d => { return y(d.user_count) + .1; })
        .attr("dy", "-.8em"); 
}
