$(function(){
	$('.collapsable-link').click(function(e){
		e.preventDefault();
		$($(this).attr('href')).toggleClass('in');
		$(this).find('i').toggleClass('icon-chevron-right').toggleClass('icon-chevron-down');
	})
});