$(document).ready(function(){

  $(document).on("click", "#admin_panel .pagination a", function() {
    $.getScript(this.href);
    return false;
  });

  $(document).on("click", "#admin_panel a.search_submit", function(){
    $.getScript(this.href);
    $('input[type=search]').val('');
    return false;
  });

  $('#admin_panel').accordion({
    collapsible: true,
    active: false,
    header: "h3",
    heightStyle: "content"
  });
});
