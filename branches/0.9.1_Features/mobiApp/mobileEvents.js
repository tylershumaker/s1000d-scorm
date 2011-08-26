/**
 * This file is part of the S1000D Transformation Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
$(function() {

	var scoPages = getArray();

	//handles .indexOf() method in IE and older browsers
	if (!Array.prototype.indexOf) {
		Array.prototype.indexOf = function(elt /* , from */) {
			var len = this.length;
			var from = Number(arguments[1]) || 0;
			from = (from < 0) ? Math.ceil(from) : Math.floor(from);
			if (from < 0)
				from += len;
			for (; from < len; from++) {
				if (from in this && this[from] === elt)
					return from;
			}
			return -1;
		};
	}

	function isNumber(o) {
		return !isNaN(o - 0);
	}

	function getCurrentLoc() {
		var loc = $('.ui-page-active').attr('data-url');
		//alert("loc = " + loc);
		if(loc===undefined){
			return -1;
		}
		for (var i = 0; i < scoPages.length; i++) {
			if (loc.indexOf(scoPages[i]) !== -1) {
				return i;
			}
		}
		
		return -1;
	}

	function findLastPage() {
		var cur = getCurrentLoc();
		//alert("last : " + cur);
		if (cur == -1) {
			cur = 1;
		} else {
			var page = scoPages[cur].split("/");
			var backPage = scoPages[cur - 1].split("/");

			if (page[0] != backPage[0]) {
				cur = 1;
			}
		}
		return "../" + scoPages[cur - 1];
	}
	function findNextPage() {
		var cur = getCurrentLoc();
		//alert("next : " + cur);
		if (cur == -1) {
			return scoPages[1];
		} else {
			if (cur == scoPages.length - 1) {
				cur = -1;
			} else {
				var page = scoPages[cur].split("/");
				var nextPage = scoPages[cur + 1].split("/");
				if (page[0] != nextPage[0]) {
					cur = -1;
				}
			}
		}
		return "../" + scoPages[cur + 1];
	}

	function goHome() {
		return "../" + scoPages[0];
	}
	

	// SWIPE LEFT EVENT
	$(document).bind('swipeleft', function(event, ui) {
		$.mobile.changePage(findNextPage(), { transition: "slide"});
	});
	// SWIPE RIGHT EVENT
	$(document).bind('swiperight', function(event, ui) {
		$.mobile.changePage(findLastPage(), { transition: "slide", reverse: true});
	});


	$('#next').live('tap', function() {
		$.mobile.changePage(findNextPage(), { transition: "slide"});
	});
	$('#last').live('tap', function() {
		$.mobile.changePage(findLastPage(), { transition: "slide", reverse: true});
	});
	$('#home').live('tap', function() {
		$.mobile.changePage(goHome(), { transition: "slidedown"});
	});
});