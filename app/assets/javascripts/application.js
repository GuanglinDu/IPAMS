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
 * Event delegation is employed to handle events triggered by elements <td><a></a></td>.
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
    // The table cell names, i.e., the td element ids, we take interest
    // cell-name -> URI pattern 
    var cellNames = { "user-name": "users" }; // must use quotes when using hyphen

    //console.log("--- .ready() in applicaiton.js: " + rowID + ", " + cellName);
    // undefined/null/false = false
    if (cellNames[cellName] === "users") {
      var dataURL = "/users/" + response.user_id;
      //console.log("dataURL: " + dataURL);
      addressUserChanged(dataURL, rowID);
    }
  });

  //event.stopPropagation();
});

/**
 * Updates the row when an IP address user changes in the Addresses/VLAN (VLANs -> VLAN) views.
 *
 * @param {String} locale - locale, either "en" or "zh_CN"
 * @param {String} dataURL - URL for ajax call
 * @param {String} rowID - the id attribute  of the row in editing as is <tr id="row-20">
 */
var addressUserChanged = function(dataURL, rowID) {
  // Retrieves the changed user's info. 
  // See users_controller#show for the response object
  $.ajax({
    url: dataURL,
    type: "GET",
    dataType: "json",

    success: function(response) {
      //console.log("--- addressUserChanged in applicaiton.js ---");
      //console.log(response);
      var lang = response.locale; // locale is already String typed
      //console.log(response.locale);

      // department pk, url, name
      var deptName = $("#" + rowID + " #department-name" + " a")
        .attr("data-pk", response.pk)
        .attr("data-url", "/" + lang + dataURL);
      if (response.department) {
        deptName.removeClass("editable-empty");
        deptName.text(response.department);
      }
      refreshInPlaceEditing(deptName, response.department);
      
      // user title pk, url, text
      var userTitle = $("#" + rowID + " #user-title" + " a")
        .attr("data-pk", response.pk)
        .attr("data-url", "/" + lang + dataURL);
      if (response.user_title) {
          userTitle.removeClass("editable-empty");
          userTitle.text(response.user_title);
      }
      refreshInPlaceEditing(userTitle, response.user_title);

      // office phone pk, url, text
      var officePhone = $("#" + rowID + " #office-phone" + " a")
        .attr("data-pk", response.pk)
        .attr("data-url", "/" + lang + dataURL)
        .text(response.office_phone);
      refreshInPlaceEditing(officePhone, response.office_phone);

      // cell phone pk, url, text
      var cellPhone = $("#" + rowID + " #cell-phone" + " a")
        .attr("data-pk", response.pk)
        .attr("data-url", "/" + lang + dataURL)
        .text(response.cell_phone);
      refreshInPlaceEditing(cellPhone, response.cell_phone);

      // building pk, url, name
      var buildingName = $("#" + rowID + " #building" + " a")
        .attr("data-pk", response.pk)
        .attr("data-url", "/" + lang + dataURL)
        .text(response.building);
      refreshInPlaceEditing(buildingName, response.building);

      // storey pk, url, name
      var storeyNum = $("#" + rowID + " #storey" + " a")
        .attr("data-pk", response.pk)
        .attr("data-url", "/" + lang + dataURL)
        .text(response.storey);
      refreshInPlaceEditing(storeyNum, response.storey);

      // room pk, url, text
      var roomNum = $("#" + rowID + " #room" + " a")
        .attr("data-pk", response.pk)
        .attr("data-url", "/" + lang + dataURL)
        .text(response.room);
      refreshInPlaceEditing(roomNum, response.room);
    }
  });
};

/**
 * Refreshes the in-place editing of a DOM node changed by other JS other than X-editable.
 *
 * @param {jQuery} obj - a jQuery object 
 * @param {String} elemText - the text of the element to be freshed 
 */
var refreshInPlaceEditing = function(obj, elemText) {
  // Removes the old editability first
  // See https://github.com/vitalets/x-editable/issues/61
  obj.editable("destroy");

  // Then, refreshes the in-place editing once more
  obj.editable({
    ajaxOptions: {
      type: "PUT",
      dataType: "json"
    },
    value: elemText,
    params: function(params) {
      var railsParams;
      railsParams = {};
      railsParams[obj.data("model")] = {};
      railsParams[obj.data("model")][params.name] = params.value;
      return railsParams;
    }
  });
};

