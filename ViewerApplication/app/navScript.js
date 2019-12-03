// JScript File

// initialize a counter for navigation clicks
var count = 1;

var current_dmc = null;
var newLocation = null;

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
	newLocation = scoPages[loc][0];

   // current_dmc = newLocation.substring(3).split("_")[0];
    current_dmc = newLocation.substring(3).split(".")[0];

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

        recordDM(ADL.verbs.attempted);
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

function recordDM(verb) {
//Make xAPI call, viewed DMC
    var statement = getDMStatement(verb);
    console.log(statement);
    console.log(JSON.stringify(statement));

    try {
        ADL.XAPIWrapper.sendStatement(statement);
    } catch (err) {
        console.log(err.message);
    }
}

function goNext()
{

    //9/1/14 issue 23 fix
   if(count >= scoPages[loc].length){
       recordDM(ADL.verbs.completed);
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
       recordDM(ADL.verbs.completed);
       var nextPage = "";
       nextPage = scoPages[loc][count];
       count++;
       setStatus("false");
       parent.content.location=nextPage;

       current_dmc = newLocation.substring(3).split(".")[0];
       recordDM(ADL.verbs.attempted);
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
        recordDM(ADL.verbs.completed);
    	count--;
    	var backPage = scoPages[loc][count-1];
        parent.content.location=backPage;
        current_dmc = newLocation.substring(3).split(".")[0];
        recordDM(ADL.verbs.attempted);
    }
    if (count == 1)
    {
        recordDM(ADL.verbs.completed);
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


function getDMStatement(verb) {

    return {
        actor: {
            objectType: "Agent",
            account: {
                homePage: scormLaunchDataJSON.lmsHomePage,
                name: window.localStorage.learnerId
            }
        },
        verb: verb,
        object: {
            id: "urn:s1000d:"+current_dmc,
            definition: {
                type: "https://w3id.org/xapi/artt/activity-types/s1000d/data-module",
            }
        },
        context: {
            contextActivities: {
                parent: [
                    {
                        id: scormLaunchDataJSON.activityId,
                        objectType: "Activity",
                        definition: {
                            type: "http://adlnet.gov/expapi/activities/lesson"
                        }
                    }
                ],
                grouping: [
                    {
                        id: "urn:s1000d:"+current_dmc,
                        objectType: "Activity",
                        definition: {
                            type: "http://adlnet.gov/expapi/activities/attempt"
                        }
                    },
                    {
                        id: scormLaunchDataJSON.courseId,
                        objectType: "Activity",
                        definition: {
                            type: "http://adlnet.gov/expapi/activities/course"
                        }
                    }
                ],
                category: [
                    {
                        id: "https://w3id.org/xapi/ARTT_Profile"
                    }
                ]
            }
        },
        result: {
            response: ""
        }
    };
}
