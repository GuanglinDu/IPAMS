/* In-place editing via x-editable-rails */
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
