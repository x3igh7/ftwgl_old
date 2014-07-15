$(document).ready(function() {
  if(typeof gon != 'undefined'){
    var teams = gon.teams;
    var $bracket_size = $('#bracket_size');
    var $show_teams = $('.bracket-calc a');
    $('div.playoff-teams-table').hide();

    $show_teams.on('click', function(e) {
      e.preventDefault();
      $('#playoff-teams').html('<tr><th>Seed</th><th>Team Name</th></tr>');
      $('div.playoff-teams-table').show('fast');
      for (var i = 0; i < $bracket_size.val(); i++) {
        $('#playoff-teams').append('<tr><td>' + (i+1) + '</td><td>' + teams[i] + '</td></tr>');
      }
    });
  }
});
