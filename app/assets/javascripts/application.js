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

/**
 * Row update event handler delegated to element tbody with id main-table-body, triggered
 * by in-place editing of a single IP address user in the VLAN/Addresses views.
 * See in-place editing in lans.js.coffee. 
 *
 * Event delegation is employed to handle events trigger by elements <td><a></a></td>.
 *
 * In case of arrays, add event listeners this way:
 * $(function() {
 *   $("tbody").each(function(index) {
 *     $(this).on("onAfterUpdate", function(event) {
 *       console.log("Cell content updated!")
 *     });
 *   });
 * });
 *
 * @param {Event} event - passed event object fired from <td><a></a></td>
 * @param {String} rowID - id attribute  of the row in editing as is <tr id="row-20">
 * @param {String} cellName - id attribute of a cell as is <td id="user-name"> 
 * @param {Object} response - response object passed from the success callback of X-Editable, see lans.js.coffee
 */
$(function() {
  $("#main-table-body").on("onAfterUpdate", "td a", function(event, rowID, cellName, response) {
    // Table cell names, td element ids, we take interest
    // cell-name -> URI pattern 
    var cellNames = { "user-name": "users" }; // must use quotes when using hyphen

    console.log(rowID + ", " + cellName);
    // undefined/null/false = false
    if (cellNames[cellName] === "users") {
      var dataURL = "/users/" + response.user_id;
      console.log("dataURL: " + dataURL);
      addressUserChanged(response.locale, dataURL, rowID);
    }
  });

  event.stopPropagation();
});

/**
 * Updates the row when a IP address user changes in the Addresses/VLAN (VLANs -> VLAN) views.
 *
 * @param {String} locale - locale, either "en" or "zh_CN"
 * @param {String} dataURL - URL for ajax call
 * @param {String} rowID - the id attribute  of the row in editing as is <tr id="row-20">
 */
var addressUserChanged = function(locale, dataURL, rowID) {
  $.ajax({
    url: dataURL,
    type: "GET",
    dataType: "json",
    success: function(response) {
      console.log("--- ajax ---");
      console.log(response);
      $("#" + rowID + " #department-name" + " a").attr("data-pk", response.pk); // department pk
      $("#" + rowID + " #department-name" + " a").attr("data-url", locale.to_s + "/" + dataURL); // department url
      $("#" + rowID + " #department-name" + " a").text(response.department); // department name
      //$("#" + rowID + " #office-phone" + " a").attr("data-pk", response.pk); // office phone pk
      //$("#" + rowID + " #office-phone" + " a").attr("data-url", locale.to_s + "/" + dataURL); // office phone url
      //$("#" + rowID + " #office-phone" + " a").text(response.office_phone); // office phone
    }
  });
};
