// JScript File

// initialize a counter for navigation clicks
var count = 1;


var loc = get_location('loc');
//alert(param);
var initialized = null;
var is_initialized = null;
var fileref = document.createElement('script');
fileref.setAttribute("type", "text/javascript");
fileref.setAttribute("src", "list.js");

function get_location(name) 
{
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regexS = "[\\?&]" + name + "=([^&#]*)";
    var regex = new RegExp(regexS);
    var results = regex.exec(window.location.href);
    if (results == null) return ""; else return results[1];

}

function startSCO()
{
	var scoPages = getArray();
	var newLocation = scoPages[loc][0];
	parent.content.location=newLocation;
	parent.topframe.indexPage("Page " + count + " of " + scoPages[loc].length + "    ");
	// call course and sco initialize
	scoInit();
	//alert("This is the course and first sco page");
}

function scoInit() 
{
    //trigger call to init the sco through the APIWrapper.js
    if (initialized == null || initialized == false) 
    {
        initialized = doInitialize();
        is_initialized = true;
    }
	if(loc == 0){
	    document.getElementById('btnBack').src = "images/toolkit_footer_11.jpg";
	    document.getElementById('btnBack').disabled = true;
	    document.getElementById('btnBack').style.cursor = "default"; // for Firefox and Chrome
	}
    if (scoPages[loc].length > 1)
    {
    	doSetValue("cmi.completion_status", "incomplete");
    }
}

function scoTerminate()
{   
//trigger call to terminate the sco through the APIWrapper.js
    initialized = doTerminate();
    is_initialized = false;
    //alert(initialized);
}

function setStatus(status)
{
	if (status == "true")
	{   
		//trigger call to set complete status the sco through the APIWrapper.js 
	    if (is_initialized == true) {
	        doSetValue("cmi.completion_status", "completed");
	    }
	}
	else
	{   
	    //trigger call to set incomplete status the sco through the APIWrapper.js 
	    if (is_initialized == true) {
	        doSetValue("cmi.completion_status", "incomplete");
	    }
	}
}

function goNext()
{
	//9/1/14 issue 23 fix
   if(count >= scoPages[loc].length){
	   setStatus("true");
	   doSetValue("adl.nav.request", "continue");
	   doSetValue("cmi.exit", "normal");
	   if (is_initialized != false)
	   {
		   scoTerminate();
	   }	   
   }
   else if (count < scoPages[loc].length)
   {
       var nextPage = "";
       nextPage = scoPages[loc][count];
       count++;
       setStatus("false");
       parent.content.location=nextPage;  
      
       // Only enable the back button if section is not an assessment

       var inString = scoPages[loc][1].indexOf("-T88");

       if (inString == -1)
       {
    	   document.getElementById('btnBack').disabled = false;
    	   document.getElementById('btnBack').style.cursor = "pointer"; // for Firefox and Chrome
    	   document.getElementById('btnBack').src = "images/toolkit_footer_04.jpg";
       }
       else{
    	   document.getElementById('btnBack').src = "images/toolkit_footer_11.jpg";
    	   document.getElementById('btnBack').disabled = true;
    	   document.getElementById('btnBack').style.cursor = "default";
       }       
   }

   parent.topframe.indexPage("Page " + count + " of " + scoPages[loc].length + "    ");
}

function goBack()
{
    document.getElementById('btnNext').disabled = false;
    document.getElementById('btnNext').style.cursor = "pointer"; // for Firefox and Chrome
    document.getElementById('btnBack').src = "images/toolkit_footer_04.jpg";
    if (count > 1)
    {
    	count--;
    	var backPage = scoPages[loc][count-1];
        parent.content.location=backPage;
    }
    if (count == 1)
    {
    	if(loc != 0){
		   doSetValue("adl.nav.request", "previous");
		   doSetValue("cmi.exit", "normal");
		   if (is_initialized != false)
		   {
			   scoTerminate();
		   }
    	}
    	else{
	    	document.getElementById('btnBack').src = "images/toolkit_footer_11.jpg";
	    	document.getElementById('btnBack').disabled = true;
	    	document.getElementById('btnBack').style.cursor = "default"; // for Firefox and Chrome
    	}
    }
    parent.topframe.indexPage("Page " + count + " of " + scoPages[loc].length + "    ");
}

function goHome()
{   
    count = 1;
    var nextPage = scoPages[loc][count-1];
    parent.content.location=nextPage;
    parent.topframe.indexPage("Page " + count + " of " + scoPages[loc].length + "    ");
}
