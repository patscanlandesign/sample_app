//custom.js

$(document).ready(function() {
	$('#micropost_content').keyup(function() {
	var maxlen = 140;
	var text = $(this).val()
  var charlen = $(this).val().length;
	var remain = maxlen - charlen;
	$('#countdown').html(remain);
	
	if (charlen > maxlen) {
		$(this).val(text.substring(0, (maxlen)));
	}
	
	});
});