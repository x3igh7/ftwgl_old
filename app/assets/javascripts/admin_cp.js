$(document).ready(function(){
  $(".management").hide();
  $(".hide-management").hide();
  $(document).on("click", ".show-management", function(){
    $(this).parent('tr').next(".management").show("slow");
    $(this).closest(".show-management").hide();
    $(this).next(".hide-management").show();
  });
  $(document).on("click", ".hide-management", function(){
    $(this).parent('tr').next('.management').hide();
    $(this).prev('.show-management').show();
    $(this).closest(".hide-management").hide();
  });
});

$(function() {
  $(document).on("click", "#users_panel .pagination a, #teams_panel .pagination a, #news_panel .pagination a", function() {
    $.getScript(this.href);
    return false;
  });
});
