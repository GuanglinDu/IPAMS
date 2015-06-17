# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# In-place editing via x-editable-rails
$ ->
  $("[data-xeditable=true]").each ->
    $(@).editable
      ajaxOptions:
        type: "PUT"
        dataType: "json"

      params: (params) ->
        railsParams = {}
        railsParams[$(@).data("model")] = {}
        railsParams[$(@).data("model")][params.name] = params.value
        return railsParams

      success: (response, newValue) ->
        #if (response.success)
        #console.log "Update succeeded. tbody event handler triggered"
        fieldName = $(@).closest("td").attr("id");
        rowID = $(@).closest("tr").attr("id"); # e.g., <tr id="row-114">
        #$(@).trigger('onAfterUpdate', [@]) # @, the anchor element
        $(@).trigger('onAfterUpdate', [rowID, fieldName])
