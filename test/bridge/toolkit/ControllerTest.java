/**
 * This file is part of the S1000D Transformation Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit;


import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import java.io.File;
import java.util.ArrayList;

/**
 *
 */
public class ControllerTest
{

    /**
     * @throws java.lang.Exception
     */
    @Before
    public void setUp() throws Exception
    {
        File output = new File(System.getProperty("user.dir") +"\\output");
        if (!(output.exists()))
        {
        	output.mkdir();
        }
    }

    /**
     * @throws java.lang.Exception
     */
    @After
    public void tearDown() throws Exception
    {
    	File output = new File(System.getProperty("user.dir") +"\\output");
        if (output.exists())
        {
        	System.out.println("Attempting to delete");
        	DeleteDirectoryOnExit(output);
        }
    }
    
    private void DeleteDirectoryOnExit(File dir)
    {
    	if (dir.isDirectory())
    	{
    		String files[] = dir.list();
    		for (int f = 0; f < files.length; f++)
        	{
        		File innerFile = new File(dir, files[f]);
        		if (innerFile.isDirectory())
        		{
        			DeleteDirectoryOnExit(innerFile);
        		}
        		else
        		{
        			innerFile.delete();
        		}
        	}
    	}
    	dir.delete();
    }
	

    /**
     * Test method for {@link bridge.toolkit.Controller#main(java.lang.String[])}.
     */
    @Test
    public void testMain()
    {
        //4.1 - SCORM
        String[] SCORM41 = {System.getProperty("user.dir") +"\\examples\\bike_SCPM_4.1\\SMC-S1000DBIKE-06RT9-00001-00.xml",
                            System.getProperty("user.dir") +"\\examples\\bike_resource_package_4.1"};
        String[] MOBI41 = {System.getProperty("user.dir") +"\\examples\\bike_SCPM_4.1\\SMC-S1000DBIKE-06RT9-00001-00.xml",
                           System.getProperty("user.dir") +"\\examples\\bike_resource_package_4.1",
                           "-mobile"};
        String[] PDF41  = {System.getProperty("user.dir") +"\\examples\\bike_SCPM_4.1\\SMC-S1000DBIKE-06RT9-00001-00.xml",
		                  System.getProperty("user.dir") +"\\examples\\bike_resource_package_4.1",
		                  "-pdf"};
        
        String[] SCORM40 = {System.getProperty("user.dir") +"\\examples\\bike_SCPM\\SMC-S1000DBIKE-06RT9-00001-00.xml",
                            System.getProperty("user.dir") +"\\examples\\bike_resource_package"};
        String[] MOBI40 = {System.getProperty("user.dir") +"\\examples\\bike_SCPM\\SMC-S1000DBIKE-06RT9-00001-00.xml",
                           System.getProperty("user.dir") +"\\examples\\bike_resource_package",
                           "-mobile"};
        String[] PDF40 = {System.getProperty("user.dir") +"\\examples\\bike_SCPM\\SMC-S1000DBIKE-06RT9-00001-00.xml",
			              System.getProperty("user.dir") +"\\examples\\bike_resource_package",
			              "-pdf"};


        String[] SCORM41WOUT = {System.getProperty("user.dir") +"\\examples\\bike_SCPM_4.1\\SMC-S1000DBIKE-06RT9-00001-00.xml",
                				System.getProperty("user.dir") +"\\examples\\bike_resource_package_4.1",
                				System.getProperty("user.dir") +"\\output"};
		String[] MOBI41WOUT = {System.getProperty("user.dir") +"\\examples\\bike_SCPM_4.1\\SMC-S1000DBIKE-06RT9-00001-00.xml",
		               		   System.getProperty("user.dir") +"\\examples\\bike_resource_package_4.1",
		               		   System.getProperty("user.dir") +"\\output",
		                       "-mobile"};
		String[] PDF41WOUT = {System.getProperty("user.dir") +"\\examples\\bike_SCPM_4.1\\SMC-S1000DBIKE-06RT9-00001-00.xml",
		                      System.getProperty("user.dir") +"\\examples\\bike_resource_package_4.1",
		                      System.getProperty("user.dir") +"\\output",
		                      "-pdf"};
		
		String[] SCORM40WOUT = {System.getProperty("user.dir") +"\\examples\\bike_SCPM\\SMC-S1000DBIKE-06RT9-00001-00.xml",
								System.getProperty("user.dir") +"\\examples\\bike_resource_package",
								System.getProperty("user.dir") +"\\output"};
		String[] MOBI40WOUT = {System.getProperty("user.dir") +"\\examples\\bike_SCPM\\SMC-S1000DBIKE-06RT9-00001-00.xml",
		                       System.getProperty("user.dir") +"\\examples\\bike_resource_package",
		                       System.getProperty("user.dir") +"\\output",
		                       "-mobile"};
		String[] PDF40WOUT = {System.getProperty("user.dir") +"\\examples\\bike_SCPM\\SMC-S1000DBIKE-06RT9-00001-00.xml",
		                      System.getProperty("user.dir") +"\\examples\\bike_resource_package",
		                      System.getProperty("user.dir") +"\\output",
		                      "-pdf"};

        Controller.main(PDF40);
    }

}
