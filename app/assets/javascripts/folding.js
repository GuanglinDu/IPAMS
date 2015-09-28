// Code goes here
function(){
  '#tx_<%= user.id%>'.on('hide.bs.collapse', function () {
   '#button'.html('<span class="glyphicon glyphicon-plus"></span><%= uas = user.addresses.first.ip %>');
  }
  '#tx_<%= user.id%>'.on('show.bs.collapse', function () {
    '#button'.html('<span class="glyphicon glyphicon-minus"></span><%= uas = user.addresses.first.ip %>');
  }
}
  <script>
  $(function(){
    $(#tx_<%= user.id%>).on('hide.bs.collapse', function () {
     $('#button').html('<span class="glyphicon glyphicon-plus"></span><%= uas = user.addresses.first.ip %>');
    })
    $(#tx_<%= user.id%>).on('show.bs.collapse', function () {
      $('#button').html('<span class="glyphicon glyphicon-minus"></span><%= uas = user.addresses.first.ip %>');
    })
  })
  </script> 
