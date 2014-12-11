$(document).ready(function(){
  $(document).on("click", "#home-news .pagination a", function() {
    $.getScript(this.href);
    return false;
  });
});
