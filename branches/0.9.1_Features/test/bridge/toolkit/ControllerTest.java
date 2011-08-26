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

/**
 *
 */
public class ControllerTest
{

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
        String[] PDF41 = {System.getProperty("user.dir") +"\\examples\\bike_SCPM_4.1\\SMC-S1000DBIKE-06RT9-00001-00.xml",
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
        
        
        Controller.main(SCORM40);
    }

}
