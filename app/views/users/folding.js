  <script>
  function folding(){
    if ('\"tx_<%="+user.id>').on('hide.bs.collapse') {
     ('button').html(\"<span class="glyphicon glyphicon-plus"></span><%= uas = " + user.addresses.first.ip + \"%>");
    }
    else{
      ('button').html(\"<span class="glyphicon glyphicon-minus"></span><%= uas = " + user.addresses.first.ip + \"%>");
    }
  }
  </script> 


