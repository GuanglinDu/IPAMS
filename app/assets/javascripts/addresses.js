/**
 * Row update event handler delegated to element tbody with id main-table-body,
 * triggered by in-place editing of a single IP address user in the
 * VLAN/Addresses views. See in-place editing in lans.js.coffee. 
 *
 * Event delegation is employed to handle events triggered by elements
 * <td><a></a></td>.
 * In case of arrays, add event listeners this way:
 * $(function() {
 *   $("tbody").each(function(index) {
 *     $(this).on("onAfterUpdate", function(event) {
 *       console.log("Cell content updated!")
 *     });
 *   });
 * });
 * @param {Event} event - event object fired from <td><a></a></td>
 * @param {String} rowID - id attribute  of the row in editing as is
 *                         <tr id="row-20">
 * @param {String} cellName - id attribute of a cell as is <td id="user-name"> 
 * @param {Object} response - response object passed from the success callback
 *                            of X-Editable, see lans.js.coffee
 */
$(function() {
  $("#main-table-body").on("onAfterUpdate", "td a",
      function(event, rowID, cellName, response) {
    // The table cell names, i.e., the td element ids, we take interest in
    // cell-name -> URI pattern 
    var cellNames = { "user-name": "users" }; // use quotes in case of hyphens
    // undefined/null/false = false
    if (cellNames[cellName] === "users") {
      var dataURL = "/users/" + response.user_id;
      addressUserChanged(dataURL, rowID);
      updateStartDate(response, rowID); 
    }
  });

  //init_btn_recycle();
  toggle_recyclable_checkbox();
  // Calls the recycle button handler
  set_btn_recycle();
})

// Initializes the recycle button
var init_btn_recycle = function() {
  $("#main-table-body tr #recycle #btn_recycle").each(function() {
    var rowID = $(this).closest("tr").attr("id");
    var txtRecycle = $("#" + rowID + " #recyclable a").text();
    if (txtRecycle == "false" || txtRecycle == "f")
      $(this).prop('disabled', true);
    else
      $(this).prop('disabled', false);
  });
};

var toggle_recyclable_checkbox = function() {
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
        var choice = (params.value != 1) ? false : true;
        params.value = choice;
        railsParams[$(this).data("model")][params.name] = params.value;
        return railsParams;
      },
      success: function(response) {
        var rowID= $(this).closest("tr").attr("id");
        $(this).trigger('setRecycle', [rowID, response]);
      }
    });
  });
};

// Handles the recycle button
var set_btn_recycle = function() {
  $("#main-table-body").on("setRecycle", "td",
                           function(event, rowID, response) {
    var btnRecycle = $("#" + rowID + " #recycle #btn_recycle");
    if (response.recyclable == false)
      btnRecycle.prop('disabled', true);
    else
      btnRecycle.prop('disabled', false);
  });
};

 /**
 * Updates the row after an IP address user changes in the Addresses/VLAN
 * (VLANs -> VLAN) views by retrieving the updated user's info first.
 * See users_controller#show for the response object.
 *
 * @param {String} locale - locale, either "en" or "zh_CN"
 * @param {String} dataURL - URL for ajax call
 * @param {String} rowID - the id attribute  of the row in editing
 *                         as is <tr id="row-20">
 */
var addressUserChanged = function(dataURL, rowID) {
  $.ajax({
    url: dataURL,
    type: "GET",
    dataType: "json",
    success: function(response) {
      var url = "/" + response.locale + dataURL;
      updateUserInfo(rowID, response, url);
    }
  });
};

/**
 * Refreshes the in-place editing of a DOM node changed by other JS
 * other than X-editable.
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
};

var updateUserInfo = function(rowID, response, url) {
  // department pk, url, text
  var deptName = $("#" + rowID + " #department-name" + " a")
    .attr("data-pk", response.pk)
    .attr("data-url", url)
    .text(response.department);
  refreshInPlaceEditing(deptName, response.department, url);
  
  // user title pk, url, text
  var userTitle = $("#" + rowID + " #user-title" + " a")
    .attr("data-pk", response.pk)
    .attr("data-url", url)
    .text(response.user_title);
  refreshInPlaceEditing(userTitle, response.user_title, url);

  // office phone pk, url, text
  var officePhone = $("#" + rowID + " #office-phone" + " a")
    .attr("data-pk", response.pk)
    .attr("data-url", url)
    .text(response.office_phone);
  refreshInPlaceEditing(officePhone, response.office_phone, url);

  // cell phone pk, url, text
  var cellPhone = $("#" + rowID + " #cell-phone" + " a")
    .attr("data-pk", response.pk)
    .attr("data-url", url)
    .text(response.cell_phone);
  refreshInPlaceEditing(cellPhone, response.cell_phone, url);

  // building pk, url, text
  var buildingName = $("#" + rowID + " #building" + " a")
    .attr("data-pk", response.pk)
    .attr("data-url", url)
    .text(response.building);
  refreshInPlaceEditing(buildingName, response.building, url);

  // storey pk, url, text
  var storeyNum = $("#" + rowID + " #storey" + " a")
    .attr("data-pk", response.pk)
    .attr("data-url", url)
    .text(response.storey);
  refreshInPlaceEditing(storeyNum, response.storey, url);

  // room pk, url, text
  var roomNum = $("#" + rowID + " #room" + " a")
    .attr("data-pk", response.pk)
    .attr("data-url", url)
    .text(response.room);
  refreshInPlaceEditing(roomNum, response.room, url);
};

function getDateTime() {
  var d = new Date(); 
  var dateTime = 
    d.getFullYear() + "-"
    + ("0"+(d.getMonth()+1)).slice(-2) + "-"
    + ("0" + d.getDate()).slice(-2) + " "
    + ("0" + d.getHours()).slice(-2) + ":"
    + ("0" + d.getMinutes()).slice(-2) + ":"
    + ("0" + d.getSeconds()).slice(-2);
  return dateTime;
}

var updateStartDate = function(response, rowID) {
  var addressID = $("#" + rowID + " #start-date" + " a").attr("data-pk");
  var addrURL = "/" + response.locale + "/addresses/" + addressID;
  var time = getDateTime();

  $.ajax({
    url: addrURL,
    type: "PUT",
    data: {address: {start_date: time}},
    dataType: "json",
  });
  $("#" + rowID + " #start-date" + " a").text(time);
};


