$users_panel = $('#users_panel');
$tournaments_panel = $('#tournaments_panel');

var createLoading = function(){
	return $('<div style="height:100%; width:100%; background:#404040; opacity:.5">' +
						'<div><div class="loading" id="floatingCirclesG" class="center"><div class="f_circleG" id="frotateG_01"></div>' +
						'<div class="f_circleG" id="frotateG_02"></div>' +
						'<div class="f_circleG" id="frotateG_03"></div>' +
						'<div class="f_circleG" id="frotateG_04"></div>' +
						'<div class="f_circleG" id="frotateG_05"></div>' +
						'<div class="f_circleG" id="frotateG_06"></div>' +
						'<div class="f_circleG" id="frotateG_07"></div>' +
						'<div class="f_circleG" id="frotateG_08"></div></div></div>');
}

var loading = function($elem){
	var $loading = createLoading();
	var newHeight = Math.max(50, $elem.height());
	var newWidth = Math.max(50, $elem.width());
	$loading.show();
	$loading.css({
		height: newHeight,
		width: newWidth,
		position: "absolute",
		top:0,
		left:0,
		zIndex: 5
	});
	$elem.css({
		position: "relative",
		height: newHeight,
		width: newWidth
	})
	$elem.append($loading);
}

var unloading = function($elem){
	$elem.find(".loading").hide();
	$elem.css({
		height: "auto",
		width: "auto"
	});
}

var findUsers = function(page){
	page = page || 1;
	loading($users_panel);	
	$.ajax({
		url: 'admin/find_user',
		data: { page: page },
		success: function(users){
			unloading($users_panel);
			$users_panel.empty();
			$users_panel.append("<th>Username</th><th>Email</th><th>Actions</th>");	
			$.each(users, function(i,user){
				bannedLink = (user.banned ? "admin/unban_user/" : "admin/ban_user/") + user.id;
				banned = user.banned ? "Unban" : "Ban";
				$users_panel.append(
					'<tr>' +
						'<td><a href="user/' + user.id + '">' + user.username + '</a></td>' +
						'<td>' + user.email + '</td>' +
						'<td><a href="' + bannedLink + '">' + banned + '</a></td>' +
					'</tr>'
				);
			});
		}
	});
}

var findTournaments = function(page){
	page = page || 1;
	loading($tournaments_panel);
	$.ajax({
		url: 'admin/find_tournament',
		data: { page: page },
		success: function(tournaments){
			unloading($tournaments_panel);
			$tournaments_panel.empty();
			$.each(tournaments, function(i,tournament){
				$tournaments_panel.append(
						'<a class="cpanel-tournament-name" href="tournaments/' + tournament.id + '">' + tournament.name + '</a><br />' +
						'<div class="faded">' + tournament.description + '</div>' +
						'<a href="">Matches</a> <a href="">Start</a> <a href="">Edit</a> <a href="">Destroy</a>'
				);
			});
		}
	});
}

findUsers();
findTournaments();