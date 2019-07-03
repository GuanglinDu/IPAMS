# Enables in-place editing
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


# Enables the role selection (dropdown)
$ ->
  $("#admin-role a").each ->
    elemText = $(@).data("value")
    url = $(@).data("url")
    refreshInPlaceEditing2($(@), elemText, url) 

  $("#admin-role a").on "adminRoleChanged", (event, obj, role) -> 
    obj.editable("destroy") # Indispensable: deleting the cache!
    obj.text(role)
    obj.data("value", role)
    refreshInPlaceEditing2(obj, role, obj.data("url")) 

# Supports a dropdown, different from function refreshInPlaceEditing.
refreshInPlaceEditing2 = (obj, elemText, url) ->
  obj.editable
    type: 'select'
    value: obj.text().trim()
    # TODO: should be extracted from the db or model
    source: [{vlaue: 0, text: 'nobody'},
             {vlaue: 1, text: 'guest'},
             {vlaue: 2, text: 'operator'},
             {vlaue: 3, text: 'expert'},
             {vlaue: 4, text: 'vip'},
             {vlaue: 5, text: 'root'}]
    ajaxOptions:
      url: url
      type: "PUT"
      dataType: "json"
    value: elemText
    params: (params) ->
      railsParams = {}
      railsParams[obj.data("model")] = {}
      railsParams[obj.data("model")][params.name] = params.value
      return railsParams
    success: (response) ->
      $(@).trigger("adminRoleChanged", [$(@), response.role])
