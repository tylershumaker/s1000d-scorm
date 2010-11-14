// JScript File

// initialize a counter for navigation clicks
var count = 1;

// create a two dimensional array to hold page filenames and page order
var module03 = new Array();
//module03[0] = new Array(3);
//module03[0][0] = "DMC-S1000DBIKE-AAA-DA2-00-00-00AA-018A-T-T10-C_001-00_en-US.xml";
//module03[0][1] = "DMC-S1000DBIKE-AAA-DA2-00-00-00AA-041A-T-T10-B_001-00_en-US.xml";
//module03[0][2] = "DMC-S1000DBIKE-AAA-DA2-00-00-00AA-041A-T-T30-C_001-00_en-US.xml";
//module03[0][3] = "DMC-S1000DBIKE-AAA-DA2-00-00-00AA-041A-T-T63-E_001-00_en-US.xml";
//module03[0][4] = "DMC-S1000DBIKE-AAA-DA2-20-00-00AA-041A-T-T42-C_001-00_en-US.xml";
//module03[0][5] = "DMC-S1000DBIKE-AAA-DA2-20-00-00AA-041A-T-T62-E_001-00_en-US.xml";
//module03[0][6] = "DDMC-S1000DBIKE-AAA-DA2-30-00-00AA-041A-T-T42-C_001-00_en-US.xml";
//module03[0][7] = "DMC-S1000DBIKE-AAA-DA2-30-00-00AA-041A-T-T61-E_001-00_en-US.xml";
//module03[0][8] = "DMC-S1000DBIKE-AAA-DA2-10-00-00AA-041A-T-T42-C_001-00_en-US.xml";
//module03[0][9] = "DMC-S1000DBIKE-AAA-DA2-10-00-00AA-041A-T-T62-E_001-00_en-US.xml";
//module03[0][10] = "DMC-S1000DBIKE-AAA-DA2-00-00-00AA-041A-T-T10-D_001-00_en-US.xml";

//module03[1][0] = "DMC-S1000DBIKE-AAA-DA2-00-00-00AA-920A-T-T10-B_001-00_en-US.xml";
//module03[1][1] = "DMC-S1000DBIKE-AAA-DA2-20-00-00AA-520A-T-T45-C_001-00_en-US.xml";
//module03[1][2] = "DMC-S1000DBIKE-AAA-DA2-20-00-00AA-720A-T-T45-C_001-00_en-US.xml";
//module03[1][3] = "DMC-S1000DBIKE-AAA-DA2-20-00-00AA-520A-T-T63-E_001-00_en-US.xml";
//module03[1][4] = "DMC-S1000DBIKE-AAA-DA2-30-00-00AA-520A-T-T45-C_001-00_en-US.xml";
//module03[1][5] = "DMC-S1000DBIKE-AAA-DA2-30-00-00AA-720A-T-T45-C_001-00_en-US.xml";
//module03[1][6] = "DMC-S1000DBIKE-AAA-DA2-30-00-00AA-520A-T-T62-E_001-00_en-US.xml";
//module03[1][7] = "DMC-S1000DBIKE-AAA-DA2-10-00-00AA-520A-T-T45-C_001-00_en-US.xml";
//module03[1][8] = "DMC-S1000DBIKE-AAA-DA2-10-00-00AA-720A-T-T45-C_001-00_en-US.xml";
//module03[1][9] = "DMC-S1000DBIKE-AAA-DA2-10-00-00AA-720A-T-T62-E_001-00_en-US.xml";
//module03[1][10] = "DMC-S1000DBIKE-AAA-DA2-00-00-00AA-920A-T-T10-D_001-00_en-US.xml";

//module03[2][0] = "DMC-S1000DBIKE-AAA-DA2-00-00-00AA-041A-T-T88-C_001-00_en-US.xml";
//module03[2][1] = "DMC-S1000DBIKE-AAA-DA2-00-00-00AA-041A-T-T82-E_001-00_en-US.xml";
//module03[2][2] = "DMC-S1000DBIKE-AAA-DA2-30-00-00AA-041A-T-T82-E_001-00_en-US.xml";
//module03[2][3] = "DMC-S1000DBIKE-AAA-DA2-20-00-00AA-920A-T-T81-E_001-00_en-US.xml";
//module03[2][4] = "DMC-S1000DBIKE-AAA-DA2-30-00-00AA-520A-T-T82-E_001-00_en-US.xml";
//module03[2][5] = "DMC-S1000DBIKE-AAA-DA2-30-00-00AA-720A-T-T81-E_001-00_en-US.xml";
//module03[2][6] = "DMC-S1000DBIKE-AAA-DA2-10-00-00AA-520A-T-T81-E_001-00_en-US.xml";
//module03[2][7] = "DMC-S1000DBIKE-AAA-DA2-10-00-00AA-720A-T-T81-E_001-00_en-US.xml";



function startSCO()
	{
		var newLocation = scoPages[0][0];
		parent.contentFrame.location=newLocation;
		parent.banner.indexPage("Page 1 of " + scoPages[0].length)
		// call course and sco initialize
		scoInit();
		//alert("This is the course and first sco page");
	}

	function scoInit() 
	{   
	//trigger call to init the sco through the APIWrapper.js 
		var result = doInitialize();
	}

	function scoTerminate()
	{   
	//trigger call to terminate the sco through the APIWrapper.js 
		var result = doTerminate();
	}
	
	function setStatus(status)
	{
		if (status == "true")
		{   
		    //trigger call to set complete status the sco through the APIWrapper.js 
			doSetValue("cmi.completion_status","completed");
		}
		else
		{   
		    //trigger call to set incomplete status the sco through the APIWrapper.js 
			doSetValue("cmi.completion_status","incomplete");
		}
	}
	
	function goNext()
	{  
	   if (count < scoPages[0].length)
	   {
	       var nextPage = "";
	       nextPage = scoPages[0][count];
	       count++;
	       setStatus("false");
	       parent.contentFrame.location=nextPage;
	      
	   }
	   if (count == scoPages[0].length)
	   {   
	       setStatus("true");
	       scoTerminate();
	       btnNext.disabled = true;
	   } 
 	       parent.banner.indexPage("Page " + count + " of " + scoPages[0].length)
	}
	
	function goBack()
	{   

	    //btnNext.disabled = false;
	    if (count == 1)
	    {
	    }
	    else
	    {   
	        count--;
	        var backPage = scoPages[0][count-1];
		parent.contentFrame.location=backPage;
	    }
            parent.banner.indexPage("Page " + count + " of " + scoPages[0].length)
	}
	
	function goHome()
	{   
	    //btnNext.disabled = false;
	    count = 1;
	    var nextPage = scoPages[0][count-1];
	    parent.contentFrame.location=nextPage;
            parent.banner.indexPage("Page " + count + " of " + scoPages[0].length)
	}

	

