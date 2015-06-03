$(document).ready(function() {
	$('div#user-profile-change-password').hide();

	$('#user-change-password').on('click', function(e){
		e.preventDefault();
		$('div#user-profile-change-password').toggle();
		$('a#user-change-password').hide();
	});
});
