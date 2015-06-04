$('#more').click(function () {
if($('.btn btn-xs.span').hasClass('glyphicon glyphicon-plus'))
{
    $('#more').html('<span class="glyphicon glyphicon-minus"></span> Less Info'); 
}
else
{      
    $('#more').html('<span class="glyphicon glyphicon-plus"></span> More Info'); 
}
}); 
