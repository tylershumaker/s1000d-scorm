// JScript File

// initialize a counter for navigation clicks
var count = 1;

// create a two dimensional array to hold page filenames and page order
var scoPages = new Array(18);
scoPages[0] = new Array(7);
//scoPages[0][0] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-A_001-00_EN-US.xml";
scoPages[0][0] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H30A_001-00_EN-US.xml";
scoPages[0][1] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H10A_001-00_EN-US.xml";
scoPages[0][2] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H11A_001-00_EN-US.xml";
scoPages[0][3] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H18A_001-00_EN-US.xml";
scoPages[0][4] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H19A_001-00_EN-US.xml";
scoPages[0][5] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H20A_001-00_EN-US.xml";
scoPages[0][6] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H40A_001-00_EN-US.xml";

scoPages[1] = new Array(1);
scoPages[1][0] = "../DMC-S1000DBIKE-AAA-DA0-00-00-00AA-932A-T-H14B_001-00_EN-US.xml";

scoPages[2] = new Array(16);
scoPages[2][0] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-041A-A_007-00_EN-US.xml";
scoPages[2][1] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-042A-A_007-00_EN-US.xml";
scoPages[2][2] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-043A-A_007-00_EN-US.xml";
scoPages[2][3] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-121A-A_007-00_EN-US.xml";
scoPages[2][4] = "../DMC-S1000DBIKE-AAA-DA0-00-00-00AA-041A-A_007-00_EN-US.xml";
scoPages[2][5] = "../DMC-S1000DBIKE-AAA-DA0-20-00-00AA-520A-A_006-00_EN-US.xml";
scoPages[2][6] = "../DMC-S1000DBIKE-AAA-DA1-00-00-00AA-041A-A_006-00_EN-US.xml";
scoPages[2][7] = "../DMC-S1000DBIKE-AAA-DA2-10-00-00AA-520A-A_007-00_EN-US.xml";
scoPages[2][8] = "../DMC-S1000DBIKE-AAA-DA2-10-00-00AA-720A-A_007-00_EN-US.xml";
scoPages[2][9] = "../DMC-S1000DBIKE-AAA-DA2-20-00-00AA-720A-A_007-00_EN-US.xml";
scoPages[2][10] = "../DMC-S1000DBIKE-AAA-DA2-20-00-00AA-520A-A_007-00_EN-US.xml";
scoPages[2][11] = "../DMC-S1000DBIKE-AAA-DA3-00-00-00AA-041A-A_006-00_EN-US.xml";
scoPages[2][12] = "../DMC-S1000DBIKE-AAA-DA4-10-00-00AA-251B-A_006-00_EN-US.xml";
scoPages[2][13] = "../DMC-S1000DBIKE-AAA-DA5-00-00-00AA-041A-A_006-00_EN-US.xml";
scoPages[2][14] = "../DMC-S1000DBIKE-AAA-DA5-10-00-00AA-041A-A_006-00_EN-US.xml";
scoPages[2][15] = "../DMC-S1000DBIKE-AAA-DA5-30-00-00AA-041A-A_006-00_EN-US.xml";

scoPages[3] = new Array(10);
scoPages[3][0] = "../DMC-S1000DBIKE-AAA-DA2-00-00-00AA-018A-T-T10C_001-00_EN-US.xml";
scoPages[3][1] = "../DMC-S1000DBIKE-AAA-DA2-00-00-00AA-041A-T-T2FB_001-00_EN-US.xml";
scoPages[3][2] = "../DMC-S1000DBIKE-AAA-DA2-00-00-00AA-041A-T-T30C_001-00_EN-US.xml";
scoPages[3][3] = "../DMC-S1000DBIKE-AAA-DA2-00-00-00AA-041A-T-T71E_001-00_EN-US.xml";
scoPages[3][4] = "../DMC-S1000DBIKE-AAA-DA2-20-00-00AA-041A-T-T42C_001-00_EN-US.xml";
scoPages[3][5] = "../DMC-S1000DBIKE-AAA-DA2-20-00-00AA-041A-T-T62E_001-00_EN-US.xml";
scoPages[3][6] = "../DMC-S1000DBIKE-AAA-DA2-30-00-00AA-041A-T-T42C_001-00_EN-US.xml";
scoPages[3][7] = "../DMC-S1000DBIKE-AAA-DA2-10-00-00AA-041A-T-T42C_001-00_EN-US.xml";
scoPages[3][8] = "../DMC-S1000DBIKE-AAA-DA2-10-00-00AA-041A-T-T62E_001-00_EN-US.xml";
scoPages[3][9] = "../DMC-S1000DBIKE-AAA-DA2-00-00-00AA-041A-T-T36D_001-00_EN-US.xml";

scoPages[4] = new Array(10);
scoPages[4][0] = "../DMC-S1000DBIKE-AAA-DA2-00-00-00AA-920A-T-T2GB_001-00_EN-US.xml";
scoPages[4][1] = "../DMC-S1000DBIKE-AAA-DA2-20-00-00AA-520A-T-T45C_001-00_EN-US.xml";
scoPages[4][2] = "../DMC-S1000DBIKE-AAA-DA2-20-00-00AA-720A-T-T45C_001-00_EN-US.xml";
scoPages[4][3] = "../DMC-S1000DBIKE-AAA-DA2-20-00-00AA-520A-T-T63E_001-00_EN-US.xml";
scoPages[4][4] = "../DMC-S1000DBIKE-AAA-DA2-30-00-00AA-520A-T-T45C_001-00_EN-US.xml";
scoPages[4][5] = "../DMC-S1000DBIKE-AAA-DA2-30-00-00AA-720A-T-T45C_001-00_EN-US.xml";
scoPages[4][6] = "../DMC-S1000DBIKE-AAA-DA2-30-00-00AA-520A-T-T62E_001-00_EN-US.xml";
scoPages[4][7] = "../DMC-S1000DBIKE-AAA-DA2-10-00-00AA-520A-T-T45C_001-00_EN-US.xml";
scoPages[4][8] = "../DMC-S1000DBIKE-AAA-DA2-10-00-00AA-720A-T-T45C_001-00_EN-US.xml";
scoPages[4][9] = "../DMC-S1000DBIKE-AAA-DA2-00-00-00AA-920A-T-T36D_001-00_EN-US.xml";

scoPages[5] = new Array(2);
scoPages[5][0] = "../DMC-S1000DBIKE-AAA-DA2-00-00-00AA-028A-T-T28C_001-00_EN-US.xml";
scoPages[5][1] = "../DMC-S1000DBIKE-AAA-DA2-00-00-00AA-041A-T-T88E_001-00_EN-US.xml";


scoPages[6] = new Array(10);
scoPages[6][0] = "../DMC-S1000DBIKE-AAA-DA4-00-00-00AA-041A-T-T10B_001-00_EN-US.xml";
scoPages[6][1] = "../DMC-S1000DBIKE-AAA-DA4-00-00-00AA-041A-T-T2FB_001-00_EN-US.xml";
scoPages[6][2] = "../DMC-S1000DBIKE-AAA-DA5-30-00-00AA-041A-T-T45C_001-00_EN-US.xml";
scoPages[6][3] = "../DMC-S1000DBIKE-AAA-DA5-30-00-00AA-041A-T-T42C_001-00_EN-US.xml";
scoPages[6][4] = "../DMC-S1000DBIKE-AAA-DA5-30-00-00AA-041A-T-T63E_001-00_EN-US.xml";
scoPages[6][5] = "../DMC-S1000DBIKE-AAA-DA5-00-00-00AA-041A-T-T4RC_001-00_EN-US.xml";
scoPages[6][6] = "../DMC-S1000DBIKE-AAA-DA5-00-00-00AA-041A-T-T63E_001-00_EN-US.xml";
scoPages[6][7] = "../DMC-S1000DBIKE-AAA-DA5-10-00-00AA-041A-T-T42C_001-00_EN-US.xml";
scoPages[6][8] = "../DMC-S1000DBIKE-AAA-DA5-10-00-00AA-041A-T-T62E_001-00_EN-US.xml";
scoPages[6][9] = "../DMC-S1000DBIKE-AAA-DA4-00-00-00AA-041A-T-T36D_001-00_EN-US.xml";

scoPages[7] = new Array(6);
scoPages[7][0] = "../DMC-S1000DBIKE-AAA-DA4-00-00-00AA-041A-T-T2GC_001-00_EN-US.xml";
scoPages[7][1] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-248A-T-T45C_001-00_EN-US.xml";
scoPages[7][2] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-258A-T-T62E_001-00_EN-US.xml";
scoPages[7][3] = "../DMC-S1000DBIKE-AAA-DA4-10-00-00AA-258A-T-T45C_001-00_EN-US.xml";
scoPages[7][4] = "../DMC-S1000DBIKE-AAA-DA4-10-00-00AA-241A-T-T63E_001-00_EN-US.xml";
scoPages[7][5] = "../DMC-S1000DBIKE-AAA-DA4-00-00-00AA-258A-T-T36D_001-00_EN-US.xml";

scoPages[8] = new Array(2);
scoPages[8][0] = "../DMC-S1000DBIKE-AAA-DA4-00-00-00AA-028A-T-T28B_001-00_EN-US.xml";
scoPages[8][1] = "../DMC-S1000DBIKE-AAA-DA4-00-00-00AA-041A-T-T88E_001-00_EN-US.xml";

scoPages[9] = new Array(8);
scoPages[9][0] = "../DMC-S1000DBIKE-AAA-DA0-00-00-00AA-041A-T-T10B_001-00_EN-US.xml";
scoPages[9][1] = "../DMC-S1000DBIKE-AAA-DA0-00-00-00AA-041A-T-T2FB_001-00_EN-US.xml";
scoPages[9][2] = "../DMC-S1000DBIKE-AAA-DA0-00-00-00AA-041A-T-T42C_001-00_EN-US.xml";
scoPages[9][3] = "../DMC-S1000DBIKE-AAA-DA0-00-00-00AA-041A-T-T63E_001-00_EN-US.xml";
scoPages[9][4] = "../DMC-S1000DBIKE-AAA-DA0-00-00-00AA-041A-T-T62E_001-00_EN-US.xml";
scoPages[9][5] = "../DMC-S1000DBIKE-AAA-DA0-00-00-00AA-041A-T-T4RC_001-00_EN-US.xml";
scoPages[9][6] = "../DMC-S1000DBIKE-AAA-DA0-00-00-00AA-041A-T-T61E_001-00_EN-US.xml";
scoPages[9][7] = "../DMC-S1000DBIKE-AAA-DA0-00-00-00AA-041A-T-T36D_001-00_EN-US.xml";

scoPages[10] = new Array(14);
scoPages[10][0] = "../DMC-S1000DBIKE-AAA-DA0-00-00-00AA-018A-T-T2GB_001-00_EN-US.xml";
scoPages[10][1] = "../DMC-S1000DBIKE-AAA-DA0-10-20-00AA-400A-T-T4JC_001-00_EN-US.xml";
scoPages[10][2] = "../DMC-S1000DBIKE-AAA-DA0-10-20-00AA-520A-T-T4JC_001-00_EN-US.xml";
scoPages[10][3] = "../DMC-S1000DBIKE-AAA-DA0-20-00-00AA-412A-T-T45C_001-00_EN-US.xml";
scoPages[10][4] = "../DMC-S1000DBIKE-AAA-DA0-20-00-00AA-520A-T-T4JC_001-00_EN-US.xml";
scoPages[10][5] = "../DMC-S1000DBIKE-AAA-DA0-10-20-00AA-400A-T-T62E_001-00_EN-US.xml";
scoPages[10][6] = "../DMC-S1000DBIKE-AAA-DA5-20-00-00AA-251C-T-T45C_001-00_EN-US.xml";
scoPages[10][7] = "../DMC-S1000DBIKE-AAA-DA5-20-00-00AA-251C-T-T62E_001-00_EN-US.xml";
scoPages[10][8] = "../DMC-S1000DBIKE-AAA-DA0-10-10-00AA-921A-T-T4JC_001-00_EN-US.xml";
scoPages[10][9] = "../DMC-S1000DBIKE-AAA-DA0-10-20-00AA-215A-T-T4JC_001-00_EN-US.xml";
scoPages[10][10] = "../DMC-S1000DBIKE-AAA-DA0-10-20-00AA-362B-T-T4JC_001-00_EN-US.xml";
scoPages[10][11] = "../DMC-S1000DBIKE-AAA-DA0-10-10-00AA-921A-T-T62E_001-00_EN-US.xml";
scoPages[10][12] = "../DMC-S1000DBIKE-AAA-DA0-10-20-00AA-921A-T-T4JC_001-00_EN-US.xml";
scoPages[10][13] = "../DMC-S1000DBIKE-AAA-DA0-00-00-00AA-200A-T-T36D_001-00_EN-US.xml";

scoPages[11] = new Array(2);
scoPages[11][0] = "../DMC-S1000DBIKE-AAA-DA0-00-00-00AA-028A-T-T28B_001-00_EN-US.xml";
scoPages[11][1] = "../DMC-S1000DBIKE-AAA-DA0-00-00-00AA-041A-T-T88E_001-00_EN-US.xml";

scoPages[12] = new Array(8);
scoPages[12][0] = "../DMC-S1000DBIKE-AAA-DA1-00-00-00AA-041A-T-T10B_001-00_EN-US.xml";
scoPages[12][1] = "../DMC-S1000DBIKE-AAA-DA1-00-00-00AA-041A-T-T2FC_001-00_EN-US.xml";
scoPages[12][2] = "../DMC-S1000DBIKE-AAA-DA1-00-00-00AA-041A-T-T4JC_001-00_EN-US.xml";
scoPages[12][3] = "../DMC-S1000DBIKE-AAA-DA1-00-00-00AA-041A-T-T62E_001-00_EN-US.xml";
scoPages[12][4] = "../DMC-S1000DBIKE-AAA-DA1-00-00-00AA-041A-T-T42C_001-00_EN-US.xml";
scoPages[12][5] = "../DMC-S1000DBIKE-AAA-DA1-00-00-00AA-041A-T-T63E_001-00_EN-US.xml";
scoPages[12][6] = "../DMC-S1000DBIKE-AAA-DA1-00-00-00AA-041A-T-T40C_001-00_EN-US.xml";
scoPages[12][7] = "../DMC-S1000DBIKE-AAA-DA1-00-00-00AA-041A-T-T36D_001-00_EN-US.xml";

scoPages[13] = new Array(7);
scoPages[13][0] = "../DMC-S1000DBIKE-AAA-DA1-00-00-00AA-041A-T-T2GB_001-00_EN-US.xml";
scoPages[13][1] = "../DMC-S1000DBIKE-AAA-DA1-00-00-00AA-310A-T-T4JC_001-00_EN-US.xml";
scoPages[13][2] = "../DMC-S1000DBIKE-AAA-DA1-00-00-00AA-310A-T-T62E_001-00_EN-US.xml";
scoPages[13][3] = "../DMC-S1000DBIKE-AAA-DA1-00-00-00AA-341A-T-T45C_001-00_EN-US.xml";
scoPages[13][4] = "../DMC-S1000DBIKE-AAA-DA1-00-00-00AA-341A-T-T63E_001-00_EN-US.xml";
scoPages[13][5] = "../DMC-S1000DBIKE-AAA-DA1-00-00-00AA-913A-T-T4JC_001-00_EN-US.xml";
scoPages[13][6] = "../DMC-S1000DBIKE-AAA-DA1-00-00-00AA-913A-T-T36D_001-00_EN-US.xml";

scoPages[14] = new Array(2);
scoPages[14][0] = "../DMC-S1000DBIKE-AAA-DA1-00-00-00AA-028A-T-T28C_001-00_EN-US.xml";
scoPages[14][1] = "../DMC-S1000DBIKE-AAA-DA1-00-00-00AA-913A-T-T88E_001-00_EN-US.xml";

scoPages[15] = new Array(14);
scoPages[15][0] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-200A-T-T10B_001-00_EN-US.xml";
scoPages[15][1] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-200A-T-T2GC_001-00_EN-US.xml";
scoPages[15][2] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-258A-T-T45C_001-00_EN-US.xml";
scoPages[15][3] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-258A-T-T63E_001-00_EN-US.xml";
scoPages[15][4] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-330A-T-T42C_001-00_EN-US.xml";
scoPages[15][5] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-663A-T-T4JC_001-00_EN-US.xml";
scoPages[15][6] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-663A-T-T62E_001-00_EN-US.xml";
scoPages[15][7] = "../DMC-S1000DLIGHTING-AAA-D00-00-00-00AA-040A-T-T42C_001-00_EN-US.xml";
scoPages[15][8] = "../DMC-S1000DLIGHTING-AAA-D00-00-00-00AA-341A-T-T45C_001-00_EN-US.xml";
scoPages[15][9] = "../DMC-S1000DLIGHTING-AAA-D00-00-00-00AA-413A-T-T42C_001-00_EN-US.xml";
scoPages[15][10] = "../DMC-S1000DLIGHTING-AAA-D00-00-00-00AA-700A-T-T45C_001-00_EN-US.xml";
scoPages[15][11] = "../DMC-S1000DLIGHTING-AAA-D00-00-00-00AA-700A-T-T62E_001-00_EN-US.xml";
scoPages[15][12] = "../DMC-S1000DBIKE-AAA-DA3-10-00-00AA-921A-T-T45C_001-00_EN-US.xml";
scoPages[15][13] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-200A-T-T36D_001-00_EN-US.xml";

scoPages[16] = new Array(6);
scoPages[16][0] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-100A-T-T2GC_001-00_EN-US.xml";
scoPages[16][1] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-121A-T-T4JC_001-00_EN-US.xml";
scoPages[16][2] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-121A-T-T63E_001-00_EN-US.xml";
scoPages[16][3] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-151A-T-T45C_001-00_EN-US.xml";
scoPages[16][4] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-151A-T-T63E_001-00_EN-US.xml";
scoPages[16][5] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-100A-T-T36C_001-00_EN-US.xml";

scoPages[17] = new Array(2);
scoPages[17][0] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-028A-T-T28C_001-00_EN-US.xml";
scoPages[17][1] = "../DMC-S1000DBIKE-AAA-D00-00-00-00AA-100A-T-T88E_001-00_EN-US.xml";

var loc = get_location('loc');
//alert(param);
var initialized = null;

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
		var newLocation = scoPages[loc][0];
		parent.content.location=newLocation;
		//parent.banner.indexPage("Page 1 of " + scoPages[loc].length)
		// call course and sco initialize
		scoInit();
		//alert("This is the course and first sco page");
	}

	function scoInit() 
	{
	    //trigger call to init the sco through the APIWrapper.js
	    if (initialized == null) 
	    {
	        initialized = doInitialize();
	    }
	}

	function scoTerminate()
	{   
	//trigger call to terminate the sco through the APIWrapper.js
	    initialized = doTerminate();
	    //alert(initialized);
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
	   if (count < scoPages[loc].length)
	   {
	       var nextPage = "";
	       nextPage = scoPages[loc][count];
	       count++;
	       setStatus("false");
	       parent.content.location=nextPage;
	      
	   }
	   if (count == scoPages[loc].length)
	   {   
	       setStatus("true");
	       scoTerminate();
	       btnNext.disabled = true;
	   } 
 	       //parent.banner.indexPage("Page " + count + " of " + scoPages[0].length)
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
	        var backPage = scoPages[loc][count-1];
		parent.content.location=backPage;
	    }
            //parent.banner.indexPage("Page " + count + " of " + scoPages[loc].length)
	}
	
	function goHome()
	{   
	    //btnNext.disabled = false;
	    count = 1;
	    var nextPage = scoPages[loc][count-1];
	    parent.content.location=nextPage;
            //parent.banner.indexPage("Page " + count + " of " + scoPages[loc].length)
	}

	

