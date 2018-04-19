# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

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
