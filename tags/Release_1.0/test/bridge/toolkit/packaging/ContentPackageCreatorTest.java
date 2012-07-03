/**
 * This file is part of the S1000D Transformation Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.packaging;

import static org.junit.Assert.*;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.jdom.JDOMException;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;


/**
 *
 */
public class ContentPackageCreatorTest
{

    String testLocation = System.getProperty("user.dir") + File.separator + "test_files\\packages";
    ContentPackageCreator cpc;
    List<File> vr;
    File test;
    /**
     * @throws java.lang.Exception
     */
    @Before
    public void setUp() throws Exception
    {
        test = new File(testLocation);
        if(test.exists())
        {
            deleteDirectory(test);
        }

    }
    
    @After
    public void tearDown() throws Exception
    {
       deleteDirectory(test);
    }

    /**
     * Test method for {@link bridge.toolkit.packaging.ContentPackageCreator#ContentPackageCreator(java.lang.String)}.
     */
    @Test
    public void testContentPackageCreatorString()
    {
        String resourcePackage = System.getProperty("user.dir") + File.separator +
        "test_files\\resource_package_slim";
        cpc = new ContentPackageCreator(resourcePackage);
        cpc.setPackagesLocation(testLocation);
        try
        {
            cpc.createPackage();
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
        catch (JDOMException e)
        {
            e.printStackTrace();
        }
        try
        {
            cpc.createPackage();
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
        catch (JDOMException e)
        {
            e.printStackTrace();
        }
        
        assertTrue(new File(testLocation+File.separator+"package1"+File.separator+"resources"
                +File.separator + "s1000d" + File.separator +
                "DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-A-H10A_001-00_EN-us.xml").exists());
    }
    
    static public boolean deleteDirectory(File path) {
        if( path.exists() ) {
          File[] files = path.listFiles();
          for(int i=0; i<files.length; i++) {
             if(files[i].isDirectory()) {
               deleteDirectory(files[i]);
             }
             else {
               files[i].delete();
             }
          }
        }
        return( path.delete() );
      }

}
