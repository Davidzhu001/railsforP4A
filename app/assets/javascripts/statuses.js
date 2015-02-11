var ready;

ready = function() {
  $(".uppie, .downie").click( function() {
    if ($(this).hasClass('highlighted')) {
      $(this).removeClass('highlighted');
    } else {
      $(this).siblings().removeClass('highlighted');
      $(this).addClass('highlighted');
    }
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('statusesLoaded', ready);
