$(document).ready(function(){
  if(typeof gon != 'undefined'){
    if(gon.challonge_url != "") {
      $('#challongeBracket').challonge(gon.challonge_url, {subdomain: '', theme: '2', multiplier: '2.0', match_width_multiplier: '1.0', show_final_results: '0', show_standings: '0'});
    }
  }

  $('#tournament_rules_dialog').dialog({
    autoOpen: false,
    buttons: [{
      text: "Close",
      click: function(){
        $(this).dialog("close");
      }
    }]
  });

  $('#tournament_rules_link').on('click', function(e){
    e.preventDefault();
    $('#tournament_rules_dialog').dialog("open");
  })
});
