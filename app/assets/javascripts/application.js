// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require_self
//= require jquery
//= require jquery_ujs
//= require_tree .

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
