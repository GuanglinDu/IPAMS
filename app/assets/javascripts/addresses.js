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
    // undefined/null/false = false
    if (cellNames[cellName] === "users") {
      var dataURL = "/users/" + response.user_id;
      addressUserChanged(dataURL, rowID);
    }
  });

  // Initializes the recycle button
  init_btn_recycle();
  // Calls the recyclable checkbox handler
  handle_recycle();
  // Calls the recycle button handler
  set_btn_recycle();
});

// Initializes the recycle button
var init_btn_recycle = function(){
  $("#main-table-body tr #recycle #btn_recycle").each(function(){
    var rowID = $(this).closest("tr").attr("id");
    var txtRecycle = $("#" + rowID + " #recyclable a").text();
    if (txtRecycle == "false" || txtRecycle == "f")
      $(this).attr('disabled', true);
    else
      $(this).attr('disabled', false);
  });
};

// Handles the recyclable checkbox
var handle_recycle = function() {
  $("#recyclable a").each(function() {
    var text = $(this).text();
    var isRecyclable = text == "true" ? "1" : "0";
    var addressID = $(this).attr("data-pk");
    var url = "/addresses/" + addressID;

    $(this).editable({
      source: [{value: 1, text: 'true'}],
      emptytext: 'false',
      value: isRecyclable,
      ajaxOptions: {
        url: url,
        type: "put",
        dataType: "json"
      }, 
      params: function(params) {
        var railsParams = {};
        railsParams[$(this).data("model")] = {};
        var choice = true;
        if (params.value != 1){
          choice = false;
        } 
        params.value = choice;
        railsParams[$(this).data("model")][params.name] = params.value;
        return railsParams;
      },
      success: function(response) {
        var rowID= $(this).closest("tr").attr("id");
        $(this).trigger('setRecycle', [ rowID, response ]);
      }
    });
  });
};

// Handles the recycle button
var set_btn_recycle = function() {
  $("#main-table-body").on("setRecycle", "td", function(event, rowID, response) {
    var btnRecycle = $("#" + rowID + " #recycle #btn_recycle");
    if (response.recyclable == false)
      btnRecycle.attr('disabled', true);
    else
      btnRecycle.attr('disabled', false);
  });
};

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
      //locale is already String typed
      var url = "/" + response.locale + dataURL;
      var addressID = $("#" + rowID + " #start-date" + " a").attr("data-pk");
      var addrURL = "/" + response.locale + "/addresses/" + addressID;
      var time = getDateTime();

      // department pk, url, text
      var deptName = $("#" + rowID + " #department-name" + " a")
        .attr("data-pk", response.pk)
        .attr("data-url", url)
        .text(response.department);
      //refreshInPlaceEditing(deptName, response.department, url);
      //refreshInPlaceEditing11(deptName, response.department);
      refreshInPlaceEditing(deptName, response.department, "");
      
      // user title pk, url, text
      var userTitle = $("#" + rowID + " #user-title" + " a")
        .attr("data-pk", response.pk)
        .attr("data-url", url)
        .text(response.user_title);
      //refreshInPlaceEditing(userTitle, response.user_title, url);
      //refreshInPlaceEditing11(userTitle, response.user_title);
      refreshInPlaceEditing(userTitle, response.user_title, "");

      // office phone pk, url, text
      var officePhone = $("#" + rowID + " #office-phone" + " a")
        .attr("data-pk", response.pk)
        .attr("data-url", url)
        .text(response.office_phone);
      //refreshInPlaceEditing(officePhone, response.office_phone, url);
      //refreshInPlaceEditing11(officePhone, response.office_phone);
      refreshInPlaceEditing(officePhone, response.office_phone, "");

      // cell phone pk, url, text
      var cellPhone = $("#" + rowID + " #cell-phone" + " a")
        .attr("data-pk", response.pk)
        .attr("data-url", url)
        .text(response.cell_phone);
      //refreshInPlaceEditing(cellPhone, response.cell_phone, url);
      //refreshInPlaceEditing11(cellPhone, response.cell_phone);
      refreshInPlaceEditing(cellPhone, response.cell_phone, "");

      // building pk, url, text
      var buildingName = $("#" + rowID + " #building" + " a")
        .attr("data-pk", response.pk)
        .attr("data-url", url)
        .text(response.building);
      //refreshInPlaceEditing(buildingName, response.building, url);
      //refreshInPlaceEditing11(buildingName, response.building);
      refreshInPlaceEditing(buildingName, response.building, "");

      // storey pk, url, text
      var storeyNum = $("#" + rowID + " #storey" + " a")
        .attr("data-pk", response.pk)
        .attr("data-url", url)
        .text(response.storey);
      //refreshInPlaceEditing(storeyNum, response.storey, url);
      //refreshInPlaceEditing11(storeyNum, response.storey);
      refreshInPlaceEditing(storeyNum, response.storey, "");

      // room pk, url, text
      var roomNum = $("#" + rowID + " #room" + " a")
        .attr("data-pk", response.pk)
        .attr("data-url", url)
        .text(response.room);
      //refreshInPlaceEditing(roomNum, response.room, url);
      //refreshInPlaceEditing11(roomNum, response.room);
      refreshInPlaceEditing(roomNum, response.room, "");

      // starttime text
      //if (response.name != "NOBODY") {
        var startDate= $("#" + rowID + " #start-date" + " a").text(time);
        refreshInPlaceEditing(startDate, time, addrURL);
      //}
    }
  });
};

/**
 * Refreshes the in-place editing of a DOM node changed by other JS other than X-editable.
 *
 * @param {jQuery} obj - a jQuery object 
 * @param {String} elemText - the text of the element to be freshed 
 * @param {url} url - the text of the element to be freshed 
 */
var refreshInPlaceEditing = function(obj, elemText, url) {
  // Removes the old editability first
  // See https://github.com/vitalets/x-editable/issues/61
  obj.editable("destroy");

  // Then, refreshes the in-place editing once more
  if ( url == "" ){
    obj.editable({
      params: function(params) {
        var railsParams = {};
        railsParams[obj.data("model")] = {};
        railsParams[obj.data("model")][params.name] = params.value;
        return railsParams;
      }
    });
  } else {
    obj.editable({
      ajaxOptions: {
        url: url,
        type: "PUT",
        dataType: "json"
      },
      value: elemText,
      params: function(params) {
        var railsParams = {};
        railsParams[obj.data("model")] = {};
        railsParams[obj.data("model")][params.name] = params.value;
        return railsParams;
      }
    });
  }
};

var refreshInPlaceEditing11 = function(obj, elemText) {
  // Removes the old editability first
  // See https://github.com/vitalets/x-editable/issues/61
  obj.editable("destroy");

  // Then, refreshes the in-place editing once more
  obj.editable({
    params: function(params) {
      var railsParams = {};
      railsParams[obj.data("model")] = {};
      railsParams[obj.data("model")][params.name] = params.value;
      return railsParams;
    }
  });
};

function getDateTime() {
    var now = new Date(); 
    var year = now.getFullYear();
    var month = now.getMonth()+1; 
    var day = now.getDate();
    var hour = now.getHours();
    var minute = now.getMinutes();
    var second = now.getSeconds(); 
    if(month.toString().length == 1) {
      var month = '0' + month;
    }
    if(day.toString().length == 1) {
      var day = '0' + day;
    }   
    if(hour.toString().length == 1) {
      var hour = '0' + hour;
    }
    if(minute.toString().length == 1) {
      var minute = '0' + minute;
    }
    if(second.toString().length == 1) {
      var second = '0' + second;
    }   
    var dateTime = year + '-' + month + '-' + day + ' ' + hour + ':' + minute + ':' + second;   
    return dateTime;
}
