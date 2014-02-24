$(function() {
  $(document).on("click", "#add_tourny_team .pagination a", function() {
    $.getScript(this.href);
    return false;
  });
});
$('#team_search').submit(function() {
  $.get(this.action, $(this).serialize(), null, "script");
  return false;
});
