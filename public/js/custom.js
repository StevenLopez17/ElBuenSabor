
  (function ($) {
  
  "use strict";

    // MENU
    $('#sidebarMenu .nav-link').on('click',function(){
      $("#sidebarMenu").collapse('hide');
    });
    
    // CUSTOM LINK
    $('.smoothscroll').click(function(){
      var el = $(this).attr('href');
      var elWrapped = $(el);
      var header_height = $('.navbar').height();
  
      scrollToDiv(elWrapped,header_height);
      return false;
  
      function scrollToDiv(element,navheight){
        var offset = element.offset();
        var offsetTop = offset.top;
        var totalScroll = offsetTop-navheight;
  
        $('body,html').animate({
        scrollTop: totalScroll
        }, 300);
      }
    });
  
  })(window.jQuery);


  // Forzar inicialización de dropdowns manualmente
document.addEventListener('DOMContentLoaded', function () {
  const dropdownTriggerList = [].slice.call(document.querySelectorAll('.dropdown-toggle'));
  dropdownTriggerList.map(function (dropdownToggleEl) {
      return new bootstrap.Dropdown(dropdownToggleEl);
  });
});

