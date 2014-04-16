$(document).ready(function() {
  var teams = gon.teams;
  var $bracket_size = $('#bracket-size input');
  var $show_teams = $('#bracket_size a');
  $('div.content-inner-inner').hide();

  console.log($teams);

  $show_teams.on('click', function(e) {
    e.preventDefault();
    $('div.content-inner-inner').show('fast');
    for (var i = 0; i < $bracket_size.val(); i++) {
      $('#playoff-teams').append('<p>' + index + ') ' + team.team.name);
    }
  });
});
