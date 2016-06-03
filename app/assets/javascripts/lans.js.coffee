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
      # See addresses_controller#show
      # Triggers the row update in addresses.js
      success: (response) ->
        cellName = $(@).closest("td").attr("id"); # e.g., <td id="user-name">
        rowID = $(@).closest("tr").attr("id"); # e.g., <tr id="row-114">
        $(@).trigger('onAfterUpdate', [rowID, cellName, response])
