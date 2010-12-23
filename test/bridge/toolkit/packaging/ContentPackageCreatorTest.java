/**
 * This file is part of the S1000D-SCORM Bridge Open Toolkit 
 * project hosted on Sourceforge.net. See the accompanying 
 * license.txt file for applicable licenses.
 */
package bridge.toolkit.packaging;

import static org.junit.Assert.*;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import bridge.toolkit.util.Keys;

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
     * Test method for {@link bridge.toolkit.packaging.ContentPackageCreator#ContentPackageCreator(java.util.List)}.
     */
    @Test
    public void testContentPackageCreatorListOfString()
    {
        //builds test validated resources list
        vr = new ArrayList<File>();
        
        File [] testVR = new File(System.getProperty("user.dir") + File.separator +
                                  "test_files\\resource_package_slim").listFiles();
        for(File file : testVR)
        {
            if(file.getName().endsWith(".xml")||(file.getName().endsWith(".jpg")))
            vr.add(file);
        }
        cpc = new ContentPackageCreator(vr);
        cpc.setPackagesLocation(testLocation);
        cpc.createPackage();
        File testFile = cpc.createPackage();
        cpc.createPackage();
        
        assertTrue(new File(testFile.getAbsolutePath()).exists());
        assertTrue(new File(testLocation+File.separator+"package3"+File.separator+"resources"
                +File.separator+"DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H10A_001-00_EN-us.xml").exists());
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
        cpc.createPackage();
        cpc.createPackage();
        
        assertTrue(new File(testLocation+File.separator+"package2"+File.separator+"resources"
                +File.separator+"DMC-S1000DBIKE-AAA-D00-00-00-00AA-932A-T-H10A_001-00_EN-us.xml").exists());
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
