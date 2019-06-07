$(function($) {
  $('[data-toggle="collapse"]').on('click', function() {
    var $this = $(this);
    var $parent = typeof($this.data('parent')) !== 'undefined' ?
                  $($this.data('parent')) : void 0;
    if ($parent === void 0) {
      $this.find('.glyphicon').toggleClass('glyphicon-plus glyphicon-minus');
      return true;
    }

    /* The open element will be closed if parent !== undefined */
    var currentIcon = $this.find('.glyphicon');
    currentIcon.toggleClass('glyphicon-plus glyphicon-minus');
    $parent.find('.glyphicon')
           .not(currentIcon)
           .removeClass('glyphicon-minus')
           .addClass('glyphicon-plus');
  });
})
