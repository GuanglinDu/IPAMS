// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
// require turbolinks: disabled due to its conflict with Bootstrap in-place editing.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require bootstrap3-editable/bootstrap-editable
//= require_tree .

/* Retrieves a record */
var getRecord = function(dataURL) {
  $.get(dataURL, function(response) {
    return response;
  });
};

/**
 * Row update event handler delegated to element tbody.
 * Event delegation is employed to handle events trigger by <td></td>.
 */
/*
$(function() {
  $("tbody").each(function(index) {
    $(this).on("onAfterUpdate", function(event) {
      console.log("Cell content updated!")
    });
  });
});
*/
$(function() {
  $("#main-table-body").on("onAfterUpdate", "td a", function(event, rowID, fieldName) {
    console.log(rowID + ", " + fieldName);
    var dataURL = $("#" + rowID + " #" + fieldName + " a").attr("data-url");
        
    event.stopPropagation();
  });
});

