//$(function() {
//  // Click recycle button to create a new history address
//  var add_history_address = function() {
//    $("#main-table-body tr #recycle #btn_recycle").each(function() {
//      $(this).click(function(response) {
//        var rowID = $(this).closest("tr").attr("id");
//        var addressID = $("#" + rowID + " #mac-address" + " a").attr("data-pk");
//          if (response.state == "created") {
//            $(this).trigger('update_recycled_address_values', [ rowID, addressID, response ]);  
//          }
//        });
//     });
//  });
//};
