/**
 * 
 */
$(function(){
	
	var scoPages = getArray();

	function isNumber(o)
	{
		return ! isNaN (o-0);
	}
	
	function getCurrentLoc()
	{
		var loc = $('.ui-page-active').attr('data-url');
	    return scoPages.indexOf(loc);
	}
	
	function findLastPage()
	{
		var cur = getCurrentLoc();
		//alert("last : " + cur);
		if(cur == -1)
		{
			cur = 1;
		}
		else
		{
			var page = scoPages[cur].split("/");
			var backPage = scoPages[cur-1].split("/");
			
			if(page[0]!=backPage[0])
			{
				cur = 1;
			}
		}
		return scoPages[cur-1];
	}
	function findNextPage()
	{
		var cur = getCurrentLoc();
		//alert("next : " + cur);
		if (cur == -1)
		{
			return scoPages[1];
		}
		else
		{
			if(cur == scoPages.length-1)
			{
				cur = -1;
			}
			else
			{
				var page = scoPages[cur].split("/");
				var nextPage = scoPages[cur+1].split("/");
				if(page[0] != nextPage[0])
				{
					cur = -1;
				}
			}
		}
		return scoPages[cur+1];
	}
	
	function goHome()
	{
		return scoPages[0];
	}
	
	// SWIPE LEFT EVENT
	$(document).bind('swipeleft',function(event, ui){
		$.mobile.changePage(findNextPage(), "slide");
	});
	// SWIPE RIGHT EVENT
	$(document).bind('swiperight',function(event, ui){
		$.mobile.changePage(findLastPage(), "fade");
	});
	
	$('#next').live('click tap', function() {
		$.mobile.changePage(findNextPage(), "slide");
	});
	$('#last').live('click tap', function() {
		$.mobile.changePage(findLastPage(), "fade");
	});
	$('#home').live('click tap', function() {
		$.mobile.changePage(goHome(),"slidedown");
	});
});